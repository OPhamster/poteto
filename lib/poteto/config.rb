# frozen_string_literal: true

require 'yaml'

module Poteto
  class ReviewerConfig
    attr_reader :exclude, :reviewer
    attr_accessor :commit_id

    def initialize(reviewer, reviewer_config)
      @reviewer = reviewer.to_sym
      @exclude = reviewer_config[:exclude] || []
    end
  end

  class Config
    attr_reader :file_path, :reviewers, :repo, :config, :commit_id
    attr_accessor :pr_id, :access_token

    DEFAULT_CONFIG_FILE = '.poteto.yaml'
    DEFAULT_CONFIGS = {
      reviewers: {
        rubocop: {
          exclude: %w[spec/ test/]
        }
      }
    }

    def initialize(file_path: DEFAULT_CONFIG_FILE)
      @config = if file_path.nil?
                  DEFAULT_CONFIGS
                elsif File.exist?(file_path)
                  deep_symbolize(YAML.load_file(file_path))
                else
                  DEFAULT_CONFIGS
                end
      @reviewers = @config.fetch(:reviewers).map { |r, rc| Poteto::ReviewerConfig.new(r, rc) }
      @access_token = @config[:access_token]
    end

    def commit_id=(commit_id)
      @reviewers.each { |r| r.commit_id = commit_id }
      @commit_id = commit_id
    end

    def deep_symbolize(h)
      if h.is_a?(Hash)
        h.to_h do |k, v|
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
      elsif dig_deeper?(h)
        h.map { |vv| deep_symbolize(vv) }
      else
        h
      end
    end

    def dig_deeper?(v)
      v.class.included_modules.include?(Enumerable)
    end
  end
end
