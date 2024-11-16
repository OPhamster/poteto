# frozen_string_literal: true

module Poteto
  class Review
    attr_accessor :path, :line, :comment
    attr_reader :raw_data

    def initialize(raw_data, file_name: nil)
      @raw_data = raw_data
      @file_name = file_name
      @path = file_name unless file_name.nil?
    end
  end

  class RubocopReview < Review
    def initialize(raw_data, file_name: nil)
      super(raw_data, file_name: file_name)
      parse
    end

    def parse
      path, @line, @comment  = @raw_data.split(",")
      @path ||= path.match(/file=(.*)$/)[1]
      @line = @line.match(/line=(\d+)/)[1].to_i
      @comment = @comment.split("::").last
      nil
    end
  end
end
