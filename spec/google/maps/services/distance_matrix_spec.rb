require 'spec_helper'
require 'vcr_helper'

describe GoogleMaps::Services::DistanceMatrix, vcr: DISTANCE_MATRIX_VCR do
  let(:origins) { 'Red Square, Moscow' }
  let(:destinations) { 'Gorky Park, Moscow' }

  subject { described_class.new origins, destinations }

  it { expect(subject.result).to be_a(Array) }
  it { expect(subject.result.size).to eq(1) }
  it { expect(subject.result.first).to be_a(GoogleMaps::Services::DistanceMatrix::Result) }

  it { expect(subject.result.first.distance.to_s).to eq('6.2 km') }
  it { expect(subject.result.first.duration.to_s).to eq('18 mins') }
end
