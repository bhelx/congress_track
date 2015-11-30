require 'net/http'
require 'json'

class SunlightApi
  KEY = ENV['SUNLIGHT_KEY']
  HOST = ENV['SUNLIGHT_HOST']

  def self.call(method, params)
    params['apikey'] = KEY
    query = params.to_a.map { |pair| "#{pair[0]}=#{pair[1]}" }.join('&')
    resp = Net::HTTP.start(HOST) do |http|
      http.get("#{method}?#{query}")
    end
    JSON.parse(resp.body)
  end

  def self.legislators_locate(zip)
    call '/legislators/locate', zip: zip
  end

end
