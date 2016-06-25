class GoogleConnect

  class << self
    def get_response(service_name, request_params, response_type = 'json', google_api_key = '')
      raise ArgumentError, 'request_params is not HashType' if request_params.class.to_s != 'Hash'
      raise ArgumentError, 'google_api_key is nil' if google_api_key.to_s.blank?
      request_params = request_params.merge({
          key: google_api_key
                                            })
      url_text = 'https://maps.googleapis.com/maps/api'
      uri = "#{url_text}/#{service_name}/#{response_type}"
      uri.query = URI.encode_www_form(request_params)
      res = Net::HTTP.get_response(uri)
      if res.code.to_i == 200
        res.body
      else
        raise res.code.to_s
      end
    end
  end

end