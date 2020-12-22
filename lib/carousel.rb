# frozen_string_literal: true

class Carousel
  # @since 0.1.0
  attr_reader :movies

  # @param [Array<VSinemas::Movie>]
  #
  # @since 0.1.0
  def initialize(movies)
    @movies = movies
  end

  # @return [Array<Hash>]
  #
  # @since 0.1.0
  def columns
    movies.map do |movie|
      {
        thumbnailImageUrl: movie.figure,
        title: movie.title[0..30],
        text: movie.date,
        actions: [
          {
            type: 'uri',
            label: '詳細資訊',
            uri: movie.detail_url
          }
        ]
      }
    end
  end

  # @return [Hash]
  #
  # @since 0.1.0
  def to_h
    {
      type: 'template',
      altText: '電影資訊',
      template: {
        type: 'carousel',
        columns: columns
      }
    }
  end
end
