module GoogleMaps
  module Services
    class Duration
      attr_reader :text, :value
      def initialize(options = {})
        raise ArgumentError, 'options is not class Hash' unless options.class.to_s == 'Hash'
        @text = options['text']
        @value = options['value']
      end

      def to_s
        @text
      end
    end
  end
end