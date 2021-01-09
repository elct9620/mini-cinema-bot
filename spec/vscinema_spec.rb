# frozen_string_literal: true

require 'spec_helper'

require_relative '../lib/vscinemas'

RSpec.describe VSCinemas do
  describe '.movies' do
    subject { described_class.movies }

    it { is_expected.to be_a(VSCinemas::MovieList) }
  end
end
