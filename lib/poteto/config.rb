# frozen_string_literal: true

require 'yaml'

module Poteto
  # Reviewer Level config i.e config for rubocop etc
  class ReviewerConfig
    attr_reader :exclude, :reviewer, :repo
    attr_accessor :commit_id, :pr_id

    def initialize(reviewer, reviewer_config, config)
      @reviewer = reviewer.to_sym
      @exclude = reviewer_config[:exclude] || []
      @repo = reviewer_config.fetch(:repository)
      @config = config
    end

    def access_token
      @config.access_token
    end
  end

  # Global level config
  class Config
    attr_reader :file_path, :reviewers, :repo, :config, :commit_id, :pr_id
    attr_accessor :access_token

    DEFAULT_CONFIG_FILE = '.poteto.yaml'
    DEFAULT_CONFIGS = {
      reviewers: {
        rubocop: {
          exclude: %w[spec/ test/]
        },
        repository: 'hjadskhald'
      }
    }.freeze

    def initialize(file_path: nil)
      file_path ||= DEFAULT_CONFIG_FILE
      @config = if File.exist?(file_path)
                  deep_symbolize(YAML.load_file(file_path))
                else
                  DEFAULT_CONFIGS
                end
      @reviewers = @config.fetch(:reviewers).map { |r, rc| Poteto::ReviewerConfig.new(r, rc, self) }
      @access_token = @config[:access_token]
    end

    def commit_id=(commit_id)
      @reviewers.each { |r| r.commit_id = commit_id }
      @commit_id = commit_id
    end

    def pr_id=(pr_id)
      @reviewers.each { |r| r.pr_id = pr_id }
      @pr_id = pr_id
    end

    # The discount `deep_symbolize` implementation
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/PerceivedComplexity
    def deep_symbolize(obj)
      if obj.is_a?(Hash)
        obj.to_h do |k, v|
          case v.class
          when Hash
            [k.to_sym, deep_symbolize(v)]
          else
            if dig_deeper?(v)
              [k.to_sym, v.map { |vv| deep_symbolize(vv) }]
            else
              [k.to_sym, v]
            end
          end
        end
      elsif dig_deeper?(obj)
        obj.map { |vv| deep_symbolize(vv) }
      else
        obj
      end
    end
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/CyclomaticComplexity

    def dig_deeper?(v)
      v.class.included_modules.include?(Enumerable)
    end
  end
end
