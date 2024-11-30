# frozen_string_literal: true

require_relative 'poteto/version'
require_relative 'poteto/generate_review'
require_relative 'poteto/post_review'
require_relative 'poteto/review'
require_relative 'poteto/config'

module Poteto
  class Error < StandardError; end

  class << self
    def config(commit_id, pr_id: nil, config_file: nil, access_token: nil)
      config = Config.new(file_path: config_file)
      config.commit_id = commit_id
      config.pr_id = pr_id unless pr_id.nil?
      config.access_token = access_token unless access_token.nil?
      config
    end

    def generate_reviews(config)
      config.reviewers.map do |reviewer_config|
        generate_review(reviewer_config)
      end
    end

    def generate_review(reviewer_config)
      case reviewer_config.reviewer
      when :rubocop
        Poteto::GenerateRubocopReview.new(reviewer_config).reviews
      else
        raise ArgumentError, "unknown Reviewer #{reviewer}"
      end
    end

    def perform(config)
      config.reviewers.map do |reviewer_config|
        reviews = generate_review(reviewer_config)
        pr = Poteto::PostReview.new(reviewer_config)
        pr.call(reviews)
      end
    end
  end
end
