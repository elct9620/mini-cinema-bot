# frozen_string_literal: true

require 'net/http'
require 'nokogiri'
require 'date'

module VSCinemas
  # @since 0.1.0
  ENDPOINT = 'https://www.vscinemas.com.tw'.freeze
  PATH = '/vsweb/film/index.aspx'

  # @since 0.1.0
  Movie = Struct.new(:title, :title_en, :date, :figure, :detail_url)

  require_relative './vscinemas/movie_item'
  require_relative './vscinemas/movie_list'

  module_function

  # Return Movie List
  #
  # @return [VSCinemas::MovieList]
  #
  # @since 0.1.0
  def movies
    MovieList.new(continue: true)
  end
end
