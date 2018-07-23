require 'spec_helper'

describe GoogleMaps::Services::Distance do
  let(:text) { '6.2 km' }
  let(:value) { 6183 }

  subject { described_class.new(text: text, value: value) }

  it 'to_s' do
    expect(subject.to_s).to eq('6.2 km')
  end
end
