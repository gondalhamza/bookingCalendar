module Responses
	class Photographer
	  attr_reader :id, :name, :availabilities, :bookings

	  def initialize(content)
	    @id = content["id"]
	    @name = content["name"]
	    @availabilities = Responses::Response.new(content["availabilities"], "availability").execute
	    @bookings = Responses::Response.new(content["bookings"], "booking").execute
	  end
	end
end