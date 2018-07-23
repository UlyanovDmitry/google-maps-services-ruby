module GoogleMaps
  module Services
    class Request
      require 'net/http'
      require 'json'

      DEFAULT_OPTIONS = { key: '' }.freeze
      FIX_OPTIONS = { output: 'json' }.freeze
      URI_GOOGLE_MAPS_API = 'https://maps.googleapis.com/maps/api'.freeze

      attr_reader :service_name, :uri, :status, :response

      def self.generate_uri(service_name, params)
        request_params = DEFAULT_OPTIONS.merge(params).merge(FIX_OPTIONS)

        result = URI([URI_GOOGLE_MAPS_API, service_name, request_params[:output]].join('/'))
        result.query = URI.encode_www_form(request_params)
        result
      end

      def initialize(service_name, params = {})
        @service_name = service_name
        @uri = self.class.generate_uri(service_name, params)
        @response = Net::HTTP.get_response(uri)
        @status = response.code

        raise GoogleMaps::Services::Exception, json_response['status'] if json_response['status'] != 'OK'
      end

      def json_response
        @json_response ||= JSON.parse response.body
      end
    end
  end
end
