require 'net/http'
require 'json'

class SunlightApi
  KEY = "77d18f5ea34c49a2ad24547cfa6cdc6a"
  HOST = "congress.api.sunlightfoundation.com"

  def self.call(method, params)
    params['apikey'] = KEY
    query= params.to_a.map { |pair| "#{pair[0]}=#{pair[1]}" }.join('&')
    resp = Net::HTTP.start(HOST) do |http|
      http.get("#{method}?#{query}")
    end
    JSON.parse(resp.body)
  end

  def self.legislators_locate(zip)
    call '/legislators/locate', zip: zip
  end

end
