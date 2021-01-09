# frozen_string_literal: true

require 'spec_helper'

require_relative '../../lib/vscinemas'

RSpec.describe VSCinemas::MovieList do
  let(:list) { described_class.new }

  describe "#doc", vcr: 'vscinemas/page1' do
    subject { list.doc }

    it { is_expected.to be_a(Nokogiri::HTML::Document) }
  end

  describe '#each', vcr: 'vscinemas/page1' do
    subject(:each) { list.each }

    it { is_expected.to be_a(Enumerator) }
    it { expect(each.to_a.size).to eq(20) }

    context '#each', vcr: 'vscinemas/page_all' do
      let(:list) { described_class.new(continue: true) }

      it { expect(each.to_a.size).to eq(47) }
    end
  end

  describe '#next?', vcr: 'vscinemas/page1' do
    subject { list.next? }

    it { is_expected.to be_truthy }

    context 'when no next page', vcr: 'vscinemas/page3' do
      let(:list) { described_class.new(page: 3) }

      it { is_expected.to be_falsy }
    end
  end

  describe '#next', vcr: 'vscinemas/page1' do
    subject { list.next }

    it { is_expected.to be_a(VSCinemas::MovieList) }

    context 'when no next page', vcr: 'vscinemas/page3' do
      let(:list) { described_class.new(page: 3) }

      it { is_expected.to be_nil }
    end
  end

  describe '#uri' do
    subject(:uri) { list.uri }

    it { is_expected.to be_a(URI) }
    it { expect(uri.to_s).to include("?p=1") }
  end

  describe '#continue?' do
    subject { list.continue? }

    it { is_expected.to be_falsy }

    context 'when continue is enabled' do
      let(:list) { described_class.new(continue: true) }

      it { is_expected.to be_truthy }
    end
  end
end
