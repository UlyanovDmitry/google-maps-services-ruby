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

  context 'use options' do
    let(:options) { {} }

    subject { described_class.new(origins, destinations, options: options).result.first }

    context 'language' do
      let(:options) { { language: 'ru-ru' } }

      it { expect(subject.distance.to_s).to eq('6,2 км') }
      it { expect(subject.duration.to_s).to eq('18 мин.') }
    end
  end

  context 'a lot of addresses' do
    let(:origins) do
      [
        'Red Square, Moscow', 'Gorky Park, Moscow', 'Moscow Kremlin', 'Moscow Zoo', 'Moscow State University',
        'Lenkom Theatre', 'Bauman Moscow State Technical University', 'Tretyakov Gallery', 'Novodevichy Convent'
      ]
    end
    let(:destinations) do
      [
        'Moscow Engineering Physics Institute', 'Yermolova Theatre', 'Moscow Engineering Physics Institute',
        'Moscow. Kolomenskoe', 'Moscow, Orlov Paleontological museum', 'Moscow, State Darwin Museum',
        'Moscow, Tsaritsyno. Park', 'Moscow, VDNKh', 'Moscow, Luzhniki'
      ]
    end
    let(:google_maps_request) { double }
    let(:json_responce) { { 'origin_addresses' => [], 'destination_addresses' => [] } }

    before { allow(google_maps_request).to receive(:json_response).and_return(json_responce) }


    it 'a new request for every slice by 8 addresses' do
      expect(GoogleMaps::Services::Request).to receive(:new).and_return(google_maps_request).exactly(4).times
      subject
    end
  end
end
