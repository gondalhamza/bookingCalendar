require_relative "./application_service.rb"

module Services
	class SlotsFinderService < Services::ApplicationService
	  def initialize(photographer)
	    @photographer = photographer
	  end

	  def call
	  	slots_of_photographer = []
	    @photographer.availabilities.each do |avail|
				res = bob(avail.starts, avail.ends, @photographer)
				(slots_of_photographer << res).flatten!
	  	end
			return slots_of_photographer
	  end

	  private
	  def bob(starts, ends, photographer, slots = [])
			slot_start = DateTime.parse(starts)
			slot_end = DateTime.parse(ends)
			
			bookings = photographer.bookings

			bookings.each do |b|
				if DateTime.parse(b.starts).between?(slot_start, slot_end)
					# slot_end = DateTime.parse(b.starts)
					slots.push(Slot.new(
									slot_start, 
									DateTime.parse(b.starts),
									photographer.id,
									photographer.name
									)
								)
					return bob(b.ends, slot_end.to_s, photographer, slots)
				end
			end
			if slot_end > slot_start
				slots.push(Slot.new(
										slot_start, 
										slot_end,
										photographer.id,
										photographer.name
										))
			end
			slots
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
									@photographer.id,
									@photographer.name
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
							@photographer.id,
							@photographer.name
							)
						)
				else
					slots.push(
						Slot.new(
							@slot_start, 
							availability_ends,
							@photographer.id,
							@photographer.name
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
	attr_accessor :start_time, :end_time, :photographer_id, :photographer_name

	def initialize(start_time, end_time, photographer_id, photographer_name)
		@start_time = start_time 
		@end_time = end_time
		@photographer_id = photographer_id
		@photographer_name = photographer_name
	end
end
