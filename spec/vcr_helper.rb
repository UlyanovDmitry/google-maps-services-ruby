require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.ignore_localhost = true
  c.configure_rspec_metadata!

  c.before_record do |i|
    i.response.body.force_encoding('UTF-8')
  end
end

DISTANCE_MATRIX_VCR = {
  cassette_name: 'distance_matrix',
  record: :once,
  allow_playback_repeats: true,
  erb: true,
  match_requests_on: %i[method uri body]
}.freeze
