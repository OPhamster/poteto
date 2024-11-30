# frozen_string_literal: true

require 'octokit'

module Poteto
  # Post Review to github
  class PostReview
    attr_reader :commit_id, :repo, :reviewer
    attr_accessor :rate_limit_lambda

    def initialize(reviewer)
      @commit_id = reviewer.commit_id
      @pr_id = reviewer.pr_id
      @repo = reviewer.repo
      @reviewer = reviewer
      @post_client = ::Octokit::Client.new(access_token: reviewer.access_token)
      @post_lambda = proc do |review|
        commit_id = review.commit_id || reviewer.commit_id
        @post_client.create_pull_request_comment(reviewer.repo, reviewer.pr_id, review.comment, commit_id,
                                                 review.path, review.line)
      end
    end

    def call(reviews)
      reviews.each do |review|
        @post_lambda.call(review)
      end
    end
  end
end
