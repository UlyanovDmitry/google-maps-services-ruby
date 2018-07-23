require 'spec_helper'

describe GoogleMaps::Services::DistanceMatrix::Result do
  let(:origin) { 'Beginning of the route' }
  let(:destination) { 'End of the route' }
  let(:status) { 'OK' }
  let(:distance) { { text: '6.2 km', value: 6183 } }
  let(:duration) { { text: '18 mins', value: 1054 } }
  let(:options) do
    {
      origin: origin,
      destination: destination,
      status: status,
      distance: distance,
      duration: duration
    }.compact
  end

  subject { described_class.new(options) }

  it 'to_s' do
    expect(subject.to_s).to eq('6.2 km 18 mins')
  end

  context 'when route not found' do
    let(:status) { 'NOT_FOUND' }
    let(:distance) { nil }
    let(:duration) { nil }

    it { expect(subject.to_s).to eq('NOT_FOUND') }
  end
end
