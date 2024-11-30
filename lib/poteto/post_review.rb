# frozen_string_literal: true

module Poteto
  class PostReview
    attr_reader :commit_id, :repo
    attr_accessor :post_lambda, :rate_limit_lambda

    # def initialize(repo, commit_id, pr_id, post_lambda, rate_limit_lambda: nil)
    def initialize(config)
      @commit_id = config.commit_id
      @pr_id = config.pr_id
      @repo = config.repo
    end

    def call(reviews)
      reviews.each do
        post_lambda.call(config, review)
      end
    end

    def post_lambda
      return @post_lambda unless @post_lambda.nil?

      @post_client = Octokit::Client.new(access_token: config.access_token)
      @post_lambda = proc do |config, review|
        @post_client.create_pull_request_comment(config.repo, config.pull_id, review.comment, config.commit_id,
                                                 review.file, review.line)
      end
    end
  end
end
