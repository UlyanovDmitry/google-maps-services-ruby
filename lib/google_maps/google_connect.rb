module GoogleMaps
  class GoogleConnect

    require 'net/http'
    require 'json'
    require 'google_maps/google_maps_exception'

    class << self

      def get_response(service_name, request_params = {})
        raise ArgumentError, 'request_params is not HashType' + "request_params == #{request_params.class}" if request_params.class.to_s != 'Hash'
        request_params = GoogleConnect.default_options.merge(request_params)
        raise ArgumentError, 'google_api_key is nil' unless request_params.key? :key
        url_text = 'https://maps.googleapis.com/maps/api'
        uri = URI "#{url_text}/#{service_name}/#{request_params[:output]}"
        uri.query = URI.encode_www_form(request_params)
        res = Net::HTTP.get_response(uri)
        if res.code.to_i == 200
          if request_params[:output] == 'json'
            res_body = JSON.parse res.body
            if res_body['status'] == 'OK'
              return res_body
            else
              raise GoogleMaps::GoogleMapsException, res_body['status']
            end
          else
            return res
          end
        else
          raise raise GoogleMaps::GoogleMapsException, "HTTP Error Code: #{res.code}"
        end
      end

      def default_options
        {
            output: 'json'
        }
      end

    end

  end
end