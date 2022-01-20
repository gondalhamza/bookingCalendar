# frozen_string_literal: true

require_relative "./application_service.rb"

module Services
  class BookingService < Services::ApplicationService
    def initialize(photographers, duration, slots)
      @photographers = photographers
      @duration = duration
      @slots = slots
    end

    def call
      valid_slots = {}

      @slots.each do |sl|
        duration_of_slot = minutes(sl)
        next if valid_slots[sl.photographer_id]
        valid_slots[sl.photographer_id] = (sl if (duration_of_slot >= @duration))
      end

      valid_slots
    end

    # def create_booking(valid_slots)
    #   valid_slots.each do |photo|

    #   end
    # end

    private
    def difference(a)

      (a.end_time - a.start_time)
    end
    def minutes(a)
      # puts "============"
      # p a.end_time
      # p a.start_time
      # puts difference(a).inspect
      # puts "============"
      (difference(a) * 24 * 60).to_i
    end
  end
end