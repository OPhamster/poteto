# frozen_string_literal: true

require_relative 'poteto/version'
require_relative 'poteto/generate_review'
require_relative 'poteto/post_review'
require_relative 'poteto/review'
require_relative 'poteto/config'

module Poteto
  class Error < StandardError; end

  class << self
    def generate_reviews(commit_id, config_file: nil)
      config = Config.new(file_path: config_file)
      config.commit_id = commit_id
      config.reviewers.map do |reviewer_config|
        case reviewer_config.reviewer
        when :rubocop
          Poteto::GenerateRubocopReview.new(reviewer_config).reviews
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
