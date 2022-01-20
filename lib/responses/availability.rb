module Responses
	class Availability
	  attr_reader :starts, :ends

	  def initialize(content)
	    @starts = content["starts"]
	    @ends = content["ends"]
	  end
	end
end