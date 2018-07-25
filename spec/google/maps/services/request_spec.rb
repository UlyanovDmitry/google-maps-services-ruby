require 'spec_helper'
require 'vcr_helper'

describe GoogleMaps::Services::Request, vcr: DISTANCE_MATRIX_VCR do
  let(:service_name) { 'distancematrix' }
  let(:origins) { 'Red Square, Moscow' }
  let(:destinations) { 'Gorky Park, Moscow' }
  let(:params) do
    {
      mode: 'driving',
      language: 'en-us',
      units: 'metric',
      origins: origins,
      destinations: destinations
    }
  end

  let(:origin_addresses) { ['Red Square, Moskva, Russia, 109012'] }
  let(:destination_addresses) { ['Gorky Central Park of Culture and Leisure, Krimsky Val, 9, Moskva, Russia, 119049'] }

  subject { described_class.new service_name, params }

  it { expect(subject.status).to eq('200') }

  it 'json_response' do
    expect(subject.json_response).to include(
      'origin_addresses' => origin_addresses,
      'destination_addresses' => destination_addresses
    )
  end

  context 'generate_uri' do
    subject { described_class.generate_uri service_name, params }

    it { expect(subject).to be_a(URI) }
    it { expect(subject.to_s).to eq('https://maps.googleapis.com/maps/api/distancematrix/json?key=&mode=driving&language=en-us&units=metric&origins=Red+Square%2C+Moscow&destinations=Gorky+Park%2C+Moscow&output=json') }
  end

  context 'when route not found' do
    let(:origins) { '' }
    let(:destinations) { '' }

    it { expect { subject }.to raise_error(GoogleMaps::Services::Exception) }
  end
end
