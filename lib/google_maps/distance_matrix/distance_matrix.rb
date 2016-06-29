module GoogleMaps
  class DistanceMatrix
    require 'google_maps/distance_matrix/distance_matrix_result'
    attr_reader :origins, :destinations, :status, :result

    def initialize(options = {})
      raise ArgumentError, 'options is not class Hash' unless options.class.to_s == 'Hash'
      origins = options[:origins]
      destinations = options[:destinations]
      origins = [origins] if origins.class.to_s == 'String'
      destinations = [destinations] if destinations.class.to_s == 'String'
      @origins = origins
      @destinations = destinations
      @google_api_key = options[:key]

      request_params = default_params.merge(options).merge({origins: self.origins.join('|'), destinations: self.destinations.join('|')})
      response = GoogleMaps::GoogleConnect.get_response 'distancematrix', request_params

      @status = response['status']
      raise GoogleMaps::GoogleMapsException, self.status if self.status != 'OK'

      result = []
      response['origin_addresses'].each_with_index do |first_address, row_item|
        response['destination_addresses'].each_with_index do |second_address, elem_item|
          result << DistanceMatrixResult.new({'origins' => first_address, 'destinations' => second_address}.merge(response['rows'][row_item]['elements'][elem_item]) )
        end
      end
      @result = result
    end


    def self.new_request(*args)
      if args.size == 1
        raise ArgumentError, 'options is not class Hash' unless args[0].class.to_s == 'Hash'
        DistanceMatrix.new_request_hash args[0]
      elsif args.size == 2
        DistanceMatrix.new_request_hash origins: args[0], destinations: args[1]
      elsif args.size == 3
        DistanceMatrix.new_request_hash origins: args[0], destinations: args[1], key: args[2]
      else
        raise ArgumentError, 'GoogleMaps::DistanceMatrix.new_request origins: args[0], destinations: args[1], key: args[2]'
      end
    end

    private

    def self.new_request_hash(options = {})
      raise ArgumentError, 'options is not class Hash' unless options.class.to_s == 'Hash'
      distance_matrix = DistanceMatrix.new options
      raise GoogleMaps::GoogleMapsException, distance_matrix.status if distance_matrix.status != 'OK'
      if distance_matrix.origins.size == 1 && distance_matrix.destinations.size == 1
        distance_matrix.result.first
      else
        distance_matrix.result
      end
    end

    attr_reader :google_api_key

    def default_params
      {
          mode: 'driving',
          language: 'ru-ru',
          # language: 'en-us',
          units: 'metric',
          key: ''
      }
    end

  end
end