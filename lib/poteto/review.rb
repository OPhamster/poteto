# frozen_string_literal: true

module Poteto
  class Review
    attr_accessor :path
    attr_accessor :line
    attr_accessor :comment

    def initialize(raw_data, file_name: nil)
      @raw_data = raw_data
      @file_name = file_name
      if file_name.present?
        @path = file_name
      end
    end
  end

  class RubocopReview < Review
    def initialize(raw_data, file_name: nil)
      super(data, file_name: file_name)
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
