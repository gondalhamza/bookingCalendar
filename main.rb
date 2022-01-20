require "pry"
require "date"

require_relative "./lib/readers/loader.rb"
require_relative "./lib/responses/response.rb"
require_relative "./src/slots_finder_service.rb"
require_relative "./src/booking_service.rb"

p "---------------"

# Read input data from json file
file = Loader::InputData.call('lib/data/input.json')

# Parse data
photopraphers = Responses::Response.new(file["photographers"], "photographer").execute

# Slots
slots_of_all_photopraphers =[]
photopraphers.each do |ph|
	slots = Services::SlotsFinderService.call(ph)
	slots_of_all_photopraphers.concat(slots)
end

p slots_of_all_photopraphers

duration = 340
# p booking = Services::BookingService.call(photopraphers, duration, slots_of_all_photopraphers)


