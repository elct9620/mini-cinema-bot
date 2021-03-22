# frozen_string_literal: true

require_relative './bot'
require_relative './carousel'

class Handler
  # @since 0.1.0
  SHARED_HEADER = { 'Content-Type' => 'text' }

  # @since 0.1.0
  SUCCESS_RESPONSE = [200, SHARED_HEADER, ["Success"]]

  # @since 0.1.0
  BAD_REQUEST_RESPONSE = [400, SHARED_HEADER, ["Bad Request"]]

  # @since 0.1.0
  KEYWORD_REGEXP = /([^\s]*)\s*([0-9]+)?/

  # @since 0.1.0
  attr_reader :body, :movies

  # @param [Hash] request environment
  #
  # @since 0.1.0
  def initialize(body, movies)
    @body = body
    @movies = movies
  end

  # Data
  #
  # Parsed Body
  #
  # @since 0.1.0
  def data
    @data ||= JSON.parse(body)
  rescue JSON::ParserError, TypeError
    @data ||= {}
  end

  # Messages
  #
  # @return [Array]
  #
  # @since 0.1.0
  def messages
    @events = (data['events'] || []).select { |event| event['type'] == 'message' }
  end

  # Return Response
  #
  # @return [Array] response
  #
  # @since 0.1.0
  def perform
    messages.each do |message|
      keyword, amount = message.dig('message', 'text').match(KEYWORD_REGEXP)[1..2]
      movies = filtered_movies(keyword).take([10, amount.to_i].max)
      reply = movies.each_slice(10).map { |movies_group| Carousel.new(movies_group).to_h }
      Bot.reply_message(message['replyToken'], reply)
    end

    SUCCESS_RESPONSE
  end

  # Filtered Movies
  #
  # @return [Array<VSCiemas::Movie>]
  #
  # @since 0.1.0
  def filtered_movies(text)
    case text
    when /最近/ then movies.reject { |movie| movie.date > DateTime.now }.sort_by(&:date).reverse
    when /近期/ then movies.sort_by(&:date).reverse
    when /隨機/ then movies.shuffle
    else movies
    end
  end
end
