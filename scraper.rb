require 'nokogiri'
require 'open-uri'

class Scraper
  attr_accessor :doc
  LOCATION_PATH = '//Listings//Listing//Location'

  def self.fetch(url)
    new(url).parse
  end

  def initialize(url)
    @doc = Nokogiri::XML(open(url))
  end

  def parse
    @doc.xpath(LOCATION_PATH).map do |location_doc|
      department = {}

      department[:unit_number] = location_doc.xpath('UnitNumber').text
      department[:street_address] = location_doc.xpath('StreetAddress').text
      department[:city] = location_doc.xpath('City').text
      department[:state] = location_doc.xpath('State').text
      department[:zip] = location_doc.xpath('Zip').text
      department
    end
  end
end
