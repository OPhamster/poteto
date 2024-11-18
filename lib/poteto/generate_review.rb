# frozen_string_literal: true

require_relative 'review'
require 'open3'

module Poteto
  class GenerateReview
    attr_reader :commit_id, :exclude, :reviews

    def initialize(commit_id, exclude: [])
      @commit_id = commit_id
      @exclude = exclude
      @reviews = []
    end
  end

  class GenerateRubocopReview < GenerateReview
    def initialize(commit_id, exclude: ["spec/", "test/"])
      super(commit_id, exclude: exclude)
      call
    end

    def call
      @reviews << rubocop_on_changes(files_change_ranges_for_rubocop)
    end

    def changed_files
      git_args = ["git", "diff", "--diff-filter=ACM", "--name-only", "#{commit_id}..HEAD"]
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
        # exit 1
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
        meta = command(["git diff #{commit_id}..HEAD -U0 -- #{f} | grep '^@@'"])
        line_nos = meta.flat_map do |m|
          remove, add = m.match(/^@@(.*)@@/)[1].strip.split()
          line_nos = []
          unless remove.nil?
            remove_start_line, _ = remove.split(",")
            line_nos << remove_start_line.to_i.abs
          end
          unless add.nil?
            add_end_line, _ = add.split(",")
            line_nos << add_end_line.to_i.abs
          end
          line_nos
        end
        [f, [line_nos.min, line_nos.max]]
      end
    end

    def files_change_ranges_for_rubocop
      change_ranges(filter_files(changed_files))
    end

    def rubocop_on_changes(file_change_ranges)
      rubocop_args = ["bundle", "exec", "rubocop", "--force-exclusion", "-fg", "-E", "--display-only-fail-level-offenses"]
      file_change_ranges.flat_map do |f, f_change_range|
        rc_args = rubocop_args + [f]
        rubocop_failures = command(rc_args, expected_status_code: 256)
        rc_relevant_failures = rubocop_failures.filter do |f|
          if f.start_with?("::error")
            failure_line = f.split(",")[1].match(/line=(\d+)/)[1].to_i
            f_change_range[0] <= failure_line && f_change_range[1] >= failure_line
          else
            false
          end
        end
        rc_relevant_failures.map do |review_data|
          RubocopReview.new(review_data, file_name: f)
        end
      end
    end
  end
end
