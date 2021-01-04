# frozen_string_literal: true

require_relative './lib/vscinemas'
require_relative './lib/signature_validator'
require_relative './lib/handler'

require 'rack'
require 'line/bot'
require 'json'
require 'oj'
Oj.mimic_JSON

movies = VSCinemas.movies.map(&:to_movie)

app = lambda do |env|
  request = Rack::Request.new(env)
  Handler.new(request.body.read, movies).perform
end

use SignatureValidator
run app
