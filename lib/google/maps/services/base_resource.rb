module GoogleMaps
  module Services
    class BaseResource
      attr_reader :text, :value

      alias_method :to_s, :text

      def initialize(text: '', value: '')
        @text = text
        @value = value
      end
    end
  end
end
