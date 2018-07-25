module GoogleMaps
  module Services
    class DistanceMatrix
      require 'active_support/core_ext/array'
      require 'google/maps/services/distance_matrix/result'

      SERVICE_NAME = 'distancematrix'.freeze

      # Limit of request elements count
      # elements_count = origins_count * destinations_count
      # when limit = 8, that elements_count = 16
      LIMIT_ADDRESS_COUNT = 8

      DEFAULT_PARAMS = {
        mode: 'driving',
        language: 'en-us',
        units: 'metric'
      }.freeze

      attr_reader :origins, :destinations, :result

      def initialize(origins, destinations, google_api_key: '', options: {})
        @origins = Array(origins)
        @destinations = Array(destinations)
        @result = []
        result_step_by_step(google_api_key, options)
      end

      private

      def result_step_by_step(google_api_key, options)
        params = DEFAULT_PARAMS.merge(key: google_api_key).merge(options)

        origins.each_slice(LIMIT_ADDRESS_COUNT) do |part_origins|
          destinations.each_slice(LIMIT_ADDRESS_COUNT) do |part_destinations|
            request(part_origins, part_destinations, params)
          end
        end
      end

      def request(origins, destinations, params)
        full_params = params.merge(origins: origins.join('|'), destinations: destinations.join('|'))
        json_parse GoogleMaps::Services::Request.new(SERVICE_NAME, full_params).json_response
      rescue GoogleMaps::Services::Exception => exp
        @result << DistanceMatrix::Result.new(origin: origins, destination: destinations, status: exp.message)
      end

      def json_parse(json_response)
        json_response['origin_addresses'].each_with_index do |first_address, row_item|
          json_response['destination_addresses'].each_with_index do |second_address, elem_item|
            @result << DistanceMatrix::Result.new(
              { origin: first_address, destination: second_address }.merge(
                json_response['rows'][row_item]['elements'][elem_item].symbolize_keys
              )
            )
          end
        end
      end
    end
  end
end
