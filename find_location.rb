require 'net/http'
require 'json'

class FindLocation
  GEOCODE_API_URL = 'https://maps.google.cn/maps/api/geocode/json'

  class << self
    def with(address)
      key = ENV['GOOGLE_API_KEY']
      raise 'Google API key not set.' unless key

      uri = URI(GEOCODE_API_URL)
      uri.query = URI.encode_www_form({ address: address, key: key })

      puts "Start request #{uri.to_s}"
      parse(Net::HTTP.get(uri))
    rescue Net::OpenTimeout
      nil
    end

    private
    def parse(response_body)
      response = JSON.parse(response_body)
      res_location = response['results']&.first.dig('geometry', 'location')
      return nil unless res_location

      result = {}
      result[:longitude] = res_location['lng']
      result[:latitude] = res_location['lat']
      result
    rescue JSON::ParserError
      nil
    end
  end
end