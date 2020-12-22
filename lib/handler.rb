# frozen_string_literal: true

require 'rack'

require_relative './bot'
require_relative './carousel'

class Handler
  # @since 0.1.0
  SHARED_HEADER = { 'Content-Type' => 'text' }
  SUCCESS_RESPONSE = [200, SHARED_HEADER, ["Success"]]
  BAD_REQUEST_RESPONSE = [400, SHARED_HEADER, ["Bad Request"]]

  # @since 0.1.0
  attr_reader :env, :movies

  # @param [Hash] request environment
  #
  # @since 0.1.0
  def initialize(env, movies)
    @env = env
    @movies = movies
  end

  # Request
  #
  # @return [Rack::Request]
  #
  # @since 0.1.0
  def request
    @request ||= Rack::Request.new(env)
  end

  # Body
  #
  # @return [Hash] parsed request body
  #
  # @since 0.1.0
  def body
    @body ||= JSON.parse(request.body.read)
  rescue JSON::ParserError
    @body ||= {}
  end

  # Messages
  #
  # @return [Array]
  #
  # @since 0.1.0
  def messages
    @events = body['events'].select { |event| event['type'] == 'message' }
  end

  # Return Response
  #
  # @return [Array] response
  #
  # @since 0.1.0
  def perform
    messages.each do |message|
      movies = filtered_movies(message.dig('message', 'text')).take(10)
      Bot.reply_message(message['replyToken'], Carousel.new(movies).to_h)
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
    when /最新/ then movies.sort_by(&:date).reverse
    when /隨機/ then movies.shuffle
    else movies
    end
  end
end
