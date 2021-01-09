# frozen_string_literal: true

require 'spec_helper'

require_relative '../lib/vscinemas'
require_relative '../lib/carousel'

RSpec.describe Carousel do
  let(:movies) do
    [
      VSCinemas::Movie.new(
        '靈魂急轉彎',
        'SOUL',
        Date.new(2020, 12, 25),
        URI.join(VSCinemas::ENDPOINT, VSCinemas::PATH, '../upload/film/film_20201106001.jpg'),
        URI.join(VSCinemas::ENDPOINT, VSCinemas::PATH, 'detail.aspx?id=4918')
      )
    ]
  end

  let(:carousel) { Carousel.new(movies) }

  describe '#columns' do
    subject(:columns) { carousel.columns }

    it { expect(columns.size).to eq(1) }
    it { expect(columns.first).to include(thumbnailImageUrl: URI.join(VSCinemas::ENDPOINT, VSCinemas::PATH, '../upload/film/film_20201106001.jpg')) }
    it { expect(columns.first).to include(title: '靈魂急轉彎') }
    it { expect(columns.first).to include(text: Date.new(2020, 12, 25)) }
    it do
      expect(columns.first).to include(actions: [
        {
          type: 'uri',
          label: '詳細資訊',
          uri: URI.join(VSCinemas::ENDPOINT, VSCinemas::PATH, 'detail.aspx?id=4918')
        }
      ])
    end
  end

  describe '#to_h' do
    subject { carousel.to_h }

    it { is_expected.to include(type: 'template') }
    it { is_expected.to include(altText: '電影資訊') }
  end
end
