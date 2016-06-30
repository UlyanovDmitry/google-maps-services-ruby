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

      result = []
      limit_address_count = 8
      origins_each_count = if self.origins.size > limit_address_count
                             origins_each_count = self.origins.size/limit_address_count
                             origins_each_count += 1 if origins_each_count*limit_address_count < self.origins.size
                          else
                            1
                           end
      origins_each_count.times do |limit_part_origins|
        start_pos = limit_part_origins*limit_address_count
        end_pos  = (limit_part_origins+1)*limit_address_count - 1
        part_origins = self.origins[start_pos.to_i..end_pos.to_i]
        if part_origins.any?

          destinations_each_count = if self.destinations.size > limit_address_count
                                      destinations_each_count = self.destinations.size/limit_address_count
                                      destinations_each_count += 1 if destinations_each_count*limit_address_count < self.destinations.size
                                    else
                                      1
                                    end
          destinations_each_count.times do |limit_part_destinations|
            start_pos = limit_part_destinations*limit_address_count
            end_pos  = (limit_part_destinations+1)*limit_address_count - 1
            part_destinations = self.destinations[start_pos.to_i..end_pos.to_i]
            if part_destinations.any?


              request_params = default_params.merge(options).merge({origins: part_origins.join('|'), destinations: part_destinations.join('|')})
              response = GoogleMaps::GoogleConnect.get_response 'distancematrix', request_params

              @status = response['status']
              raise GoogleMaps::GoogleMapsException, self.status if self.status != 'OK'

              response['origin_addresses'].each_with_index do |first_address, row_item|
                response['destination_addresses'].each_with_index do |second_address, elem_item|
                  result << DistanceMatrixResult.new({'origins' => first_address, 'destinations' => second_address}.merge(response['rows'][row_item]['elements'][elem_item]) )
                end
              end

            end
          end


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