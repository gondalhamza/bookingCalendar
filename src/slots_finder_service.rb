require_relative "./application_service.rb"

module Services
	class SlotsFinderService < Services::ApplicationService
	  def initialize(photographer)
	    @photographer = photographer
	  end

	  def call
	  	slots_of_photographer = []
	  	begin
		    @photographer.availabilities.each do |avail|
					res = available_slot(avail.starts, avail.ends, @photographer)
					(slots_of_photographer << res).flatten!
		  	end
				return slots_of_photographer
			rescue
				p "error iin slots"
				return slots_of_photographer
			end
	  end

	  private

		def difference(a)
			DateTime.parse(a.starts) - DateTime.parse(a.ends)
		end
		def self.minutes(a)
			(difference(a) * 24 * 60).to_i
		end

		def available_slot(starts, ends, photographer)
			begin
				@slot_start = DateTime.parse(starts)
				availability_ends = DateTime.parse(ends)

				slots = []
				@slot_item_start = @slot_start
				slot_item_end = availability_ends
				
				@bookings = photographer.bookings

				if @bookings != []
					@bookings.each do |obj|

						if @slot_item_start.between?(DateTime.parse(obj.starts), DateTime.parse(obj.ends)) # if exists in the resered slot
							@slot_item_start = DateTime.parse(obj.ends)
						elsif @slot_item_start <= DateTime.parse(obj.starts) #if reserved slot is behind or after the current time
							slots.push(
								Slot.new(
									@slot_item_start, 
									DateTime.parse(obj.starts),
									@photographer.id
									)
								)
							@slot_item_start = DateTime.parse(obj.ends)

						elsif (slot_item_start > DateTime.parse(obj.starts))
							@slot_item_start = DateTime.parse(obj.ends)
						end
					end	
					slots.push(
						Slot.new(
							@slot_item_start, 
							availability_ends,
							@photographer.id
							)
						)
				else
					slots.push(
						Slot.new(
							@slot_start, 
							availability_ends,
							@photographer.id
							)
						)
				end
				return slots
			rescue
				p "error"
				return []
			end
		end
	end
end


class Slot
	attr_accessor :start_time, :end_time

	def initialize(start_time, end_time, photographer_id)
		@start_time = start_time 
		@end_time = end_time
		@photographer_id = photographer_id
	end
end
