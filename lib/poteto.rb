# frozen_string_literal: true

require_relative "poteto/version"
require_relative "poteto/generate_review"
require_relative "poteto/post_review"
require_relative "poteto/review"
require "yaml"

module Poteto
  class Error < StandardError; end

  class << self
    DEFAULT_CONFIG_FILE = "poteto.yaml"
    def generate_reviews(commit_id, config_file)
      config_file ||= DEFAULT_CONFIG_FILE
      config = YAML.load_file(config_file)
      config.fetch("reviewers").map do |reviewer|
        case reviewer.to_sym
        when :rubocop
          Poteto::GenerateRubocopReview.new(commit_id).reviews
        else
          raise ArgumentError, "unknown Reviewer #{reviewer}"
        end
      end
    end

    def perform(commit_id, pr_id, repo, config_file: nil)
      generate_reviews(commit_id, config_file).each do |reviews|
        post_reviews(reviews, commit_id, pr_id, repo)
      end
    end

    def post_reviews(reviews, commit_id, pr_id, repo); end
  end
end
