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

use SignatureValidator
run ->(env) { Handler.new(env, movies).perform }
