module Responses
	class Booking
	  attr_reader :id, :starts, :ends

	  def initialize(content)
	    @id = content["id"]
	    @starts = content["starts"]
	    @ends = content["ends"]
	  end
	end
end