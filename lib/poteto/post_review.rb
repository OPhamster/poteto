# frozen_string_literal: true

module Poteto
  class PostReview
    attr_reader :pr_id, :commit_id, :post_lambda, :rate_limit_lambda, :repo

    def initialize(repo, commit_id, pr_id, post_lambda, rate_limit_lambda: nil)
      @commit_id = commit_id
      @pr_id = pr_id
      @repo = repo
      @post_lambda = post_lambda
      @rate_limit_lambda = rate_limit_lambda
    end

    def call(reviews)
      reviews.each do
        rate_limit_lambda&.call
        post_lambda.call(repo, pr_id, commit_id, review.file, review.line, review.comment)
      end
    end
  end
end
