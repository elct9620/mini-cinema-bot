# frozen_string_literal: true

require 'singleton'
require 'forwardable'

class Bot
  class << self
    extend Forwardable

    delegate %i[client] => :instance
    delegate %i[reply_message] => :client
  end

  include Singleton

  # @since 0.1.0
  attr_reader :client

  # @since 0.1.0
  def initialize
    @client = Line::Bot::Client.new do |config|
      config.channel_id = ENV["LINE_CHANNEL_ID"]
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end
  end
end
