require 'spec_helper'

describe GoogleMaps::Services::Duration do
  let(:text) { '18 mins' }
  let(:value) { 1054 }

  subject { described_class.new(text: text, value: value) }

  it 'to_s' do
    expect(subject.to_s).to eq('18 mins')
  end
end
