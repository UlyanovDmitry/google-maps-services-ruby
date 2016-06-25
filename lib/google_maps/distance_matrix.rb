module GoogleMaps
  class DistanceMatrix
    attr_reader :start_address, :finish_address, :google_api_key, :distance, :duration

    def initialize(start_address, finish_address, google_api_key = '')
      @start_address = start_address
      @finish_address = finish_address
      @google_api_key = google_api_key
      self.calc
    end

    def calc
      request_params = default_params.merge({key: self.google_api_key, origins: self.start_address, destinations: self.finish_address})
      response = GoogleMaps::GoogleConnect.get_response 'distancematrix', request_params
      first_row_hash = response['rows'].first['elements'].first
      if first_row_hash['status'] == 'OK'
        @distance = Distance.new first_row_hash['distance']['text'], first_row_hash['distance']['value']
        @duration = Duration.new first_row_hash['duration']['text'], first_row_hash['duration']['value']
      else
        raise GoogleMaps::GoogleMapsException, first_row_hash['status']
      end
    end

    private

    def default_params
      {
          mode: 'driving',
          language: 'ru-ru',
          units: 'metric'
      }
    end
  end

  class Distance
    attr_reader :text, :value
    def initialize(text, value)
      @text = text
      @value = value
    end

    def to_s
      @text
    end
  end

  class Duration < Distance
  end
end