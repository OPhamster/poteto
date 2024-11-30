# frozen_string_literal: true

require 'octokit'

module Poteto
  class PostReview
    attr_reader :commit_id, :repo, :reviewer
    attr_accessor :post_lambda, :rate_limit_lambda

    # def initialize(repo, commit_id, pr_id, post_lambda, rate_limit_lambda: nil)
    def initialize(reviewer)
      @commit_id = reviewer.commit_id
      @pr_id = reviewer.pr_id
      @repo = reviewer.repo
      @reviewer = reviewer
    end

    def call(reviews)
      reviews.each do |review|
        post_lambda.call(reviewer, review)
      end
    end

    def post_lambda
      return @post_lambda unless @post_lambda.nil?

      @post_client = ::Octokit::Client.new(access_token: reviewer.access_token)
      @post_lambda = proc do |reviewer, review|
        commit_id = review.commit_id || reviewer.commit_id
        @post_client.create_pull_request_comment(reviewer.repo, reviewer.pr_id, review.comment, commit_id,
                                                 review.path, review.line)
      end
    end
  end
end
