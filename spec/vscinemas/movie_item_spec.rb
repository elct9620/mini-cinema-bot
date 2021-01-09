# frozen_string_literal: true

# frozen_string_literal: true

require 'spec_helper'

require_relative '../../lib/vscinemas'

RSpec.describe VSCinemas::MovieItem do
  let(:element) { Nokogiri::HTML(File.read(Bundler.root.join('fixtures/vscinemas/movie.html'))) }
  let(:item) { described_class.new(element) }

  describe '#title' do
    subject { item.title }

    it { is_expected.to include('靈魂急轉彎') }
  end

  describe '#title_en' do
    subject { item.title_en }

    it { is_expected.to include('SOUL') }
  end

  describe '#date' do
    subject { item.date }

    it { is_expected.to be_a(Date) }
    it { is_expected.to eq(Date.new(2020, 12, 25)) }

    context 'when no date' do
      before { allow(Date).to receive(:parse).and_raise(ArgumentError) }

      it { is_expected.to be_nil }
    end
  end

  describe '#detial_url' do
    subject(:detail_url) { item.detail_url }

    it { expect(detail_url.to_s).to include('detail.aspx?id=4918') }
  end

  describe '#figure' do
    subject(:figure) { item.figure }

    it { expect(figure.to_s).to include('upload/film/film_20201106001.jpg') }
  end

  describe '#to_h' do
    subject { item.to_h }

    it { is_expected.to include(title: '靈魂急轉彎') }
    it { is_expected.to include(title_en: 'SOUL') }
    it { is_expected.to include(date: Date.new(2020, 12, 25)) }
    it { is_expected.to include(detail_url: URI.join(VSCinemas::ENDPOINT, VSCinemas::PATH, 'detail.aspx?id=4918')) }
    it { is_expected.to include(figure: URI.join(VSCinemas::ENDPOINT, VSCinemas::PATH, '../upload/film/film_20201106001.jpg')) }
  end

  describe '#to_movie' do
    subject { item.to_movie }

    it { is_expected.to be_a(VSCinemas::Movie) }
  end
end
