module GoogleMaps
  module Services
    class DistanceMatrix
      class Result
        attr_reader :origin, :destination, :distance, :duration, :status

        def initialize(origin:, destination:, status:, distance: {}, duration: {})
          @origin = origin.to_s
          @destination = destination.to_s
          @status = status.to_s
          @distance = Distance.new distance.symbolize_keys
          @duration = Duration.new duration.symbolize_keys
          @status = status.to_s
        end

        def to_s
          status == 'OK' ? "#{distance} #{duration}" : status
        end
      end
    end
  end
end
