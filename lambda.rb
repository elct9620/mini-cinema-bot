# frozen_string_literal: true

require_relative './lib/vscinemas'
require_relative './lib/bot'
require_relative './lib/handler'

require 'line/bot'
require 'json'
require 'oj'
Oj.mimic_JSON

BAD_REQUEST_RESPONSE = {
  statusCode: 400,
  headers: {
    "Content-Type" => "text/plain"
  },
  body: "Bad Request"
}

$movies = VSCinemas.movies.map(&:to_movie)

def signature_valid?(event)
  signature = event.dig('headers', 'x-line-signature')
  body = event['body']

  Bot.client.validate_signature(body, signature)
end

def main(event:, context:)
  return BAD_REQUEST_RESPONSE unless signature_valid?(event)

  status, headers, body = Handler.new(event['body'], $movies).perform
  { statusCode: status, headers: headers, body: body.join }
end
