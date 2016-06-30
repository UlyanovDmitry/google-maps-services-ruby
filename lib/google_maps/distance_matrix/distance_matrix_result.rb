module GoogleMaps
  class DistanceMatrixResult
    require 'google_maps/distance'
    require 'google_maps/duration'
    attr_reader :origins, :destinations, :distance, :duration, :status

    def initialize(options = {})
      raise ArgumentError, 'options is not class Hash' unless options.class.to_s == 'Hash'
      @origins = options['origins'].to_s
      @destinations = options['destinations'].to_s
      puts "#{options['distance']}"
      @status = options['status'].to_s
      if @status == 'OK'
        @distance = Distance.new options['distance']
        @duration = Duration.new options['duration']
      else
        @distance = Distance.new text: '', value: ''
        @duration = Duration.new text: '', value: ''
      end
    end

    def to_s
      "#{self.origins} - #{self.destinations}: #{self.distance} #{self.duration}"
    end

  end
end