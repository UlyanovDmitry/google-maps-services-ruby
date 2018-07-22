require 'spec_helper'
require 'vcr_helper'

describe 'DistanceMatrix', vcr: DISTANCE_MATRIX_VCR do
  let(:origins) { 'Red Square, Moscow' }
  let(:destinations) { 'Gorky Park, Moscow' }

  it 'should new_request' do
    distance_matrix = GoogleMaps::Services::DistanceMatrix.new_request origins, destinations

    expect(distance_matrix.distance.to_s).to eq('6,2 км')
  end
end