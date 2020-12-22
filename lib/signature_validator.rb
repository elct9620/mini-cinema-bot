# frozen_string_literal: true

require_relative './bot'

class SignatureValidator
  # @since 0.1.0
  attr_reader :app

  # @param [Object] rack app
  #
  # @since 0.1.0
  def initialize(app)
    @app = app
  end

  # @param [Object] rack env
  #
  # @return [Boolean]
  #
  # @since 0.1.0
  def signature_valid?(env)
    signature = env['HTTP_X_LINE_SIGNATURE']
    body = env[Rack::RACK_INPUT].read
    env[Rack::RACK_INPUT].rewind
    Bot.client.validate_signature(body, signature)
  end

  # @param [Object] rack env
  #
  # @since 0.1.0
  def call(env)
    return [400, { 'Content-Type' => 'text/plain' }, ["Bad Request"]] unless signature_valid?(env)

    app.call(env)
  end
end
