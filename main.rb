require_relative 'scraper'
require_relative 'find_location'

departments = Scraper.fetch('http://www.related.com/feeds/ZillowAvailabilities.xml')

departments_with_locations = departments.map do |department|
  address = "#{department[:street_address]}, #{department[:city]}, #{department[:state]}"
  location = FindLocation.with(address)
  department[:location] = location if location
  department
end

