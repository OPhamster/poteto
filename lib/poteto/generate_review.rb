# frozen_string_literal: true

require_relative 'review'
require 'open3'

module Poteto
  class GenerateReview
    attr_reader :commit_id, :exclude, :reviews

    def initialize(config)
      @commit_id = config.commit_id
      @exclude = config.exclude
      @reviews = []
    end

    def changed_files
      git_args = ['git', 'diff', '--diff-filter=ACM', '--name-only', "#{@commit_id}..HEAD"]
      command(git_args)
    end

    def command(command, expected_status_code: 0)
      files_str, stderr_str, status = Open3.capture3(*command)
      if status.success? || status.to_i == expected_status_code
        files_str.lines.map(&:strip)
      else
        puts "exited with #{status.to_i}"
        puts stderr_str
        puts files_str
        exit 1
      end
    end

    def filter_files(files)
      if exclude.empty?
        files
      else
        files.reject { |f| exclude.any? { |e| f.include?(e) } }
      end
    end

    def change_ranges(files)
      files.to_h do |f|
        meta = command(["git diff #{@commit_id}..HEAD -U0 -- #{f} | grep '^@@'"])
        # get the last commit that changed this file. It may not be the commit that
        # actually caused the violations. Baby steps. Github doesn't seem to complain
        commit_id = command(["git log -n 1 --pretty=format:%H -- #{f}"])[0]
        line_nos = meta.map do |m|
          remove, add = m.match(/^@@(.*)@@/)[1].strip.split
          hunk_line_nos = []
          unless remove.nil?
            remove_start_line, = remove.split(',')
            hunk_line_nos << remove_start_line.to_i.abs
          end
          unless add.nil?
            # the separation into components is just for readability
            add_end_line, additions = add.split(',')
            hunk_line_nos << [add_end_line, additions].map(&:to_i).sum
          end
          hunk_line_nos.minmax
        end
        [f, { line_nos: line_nos, commit_id: commit_id }]
      end
    end
  end

  class GenerateRubocopReview < GenerateReview
    def initialize(config)
      super(config)
      call
    end

    def call
      @reviews << rubocop_on_changes(files_change_ranges_for_rubocop)
      @reviews.flatten!
      @reviews
    end

    def files_change_ranges_for_rubocop
      change_ranges(filter_files(changed_files))
    end

    def rubocop_on_changes(file_change_ranges)
      rubocop_args = ['bundle', 'exec', 'rubocop', '--force-exclusion', '-fg', '-E',
                      '--display-only-fail-level-offenses']
      file_change_ranges.flat_map do |f, f_change_ranges|
        rc_args = rubocop_args + [f]
        rubocop_failures = command(rc_args, expected_status_code: 256)
        rc_relevant_failures = rubocop_failures.filter do |failure|
          if failure.start_with?('::error')
            failure_line = failure.split(',')[1].match(/line=(\d+)/)[1].to_i
            f_change_ranges[:line_nos].any? do |(hunk_start, hunk_end)|
              hunk_start <= failure_line && hunk_end >= failure_line
            end
          else
            false
          end
        end
        rc_relevant_failures.map do |review_data|
          RubocopReview.new(review_data, file_name: f, commit_id: f_change_ranges[:commit_id])
        end
      end
    end
  end
end
