require "json"
require_relative "./photographer.rb"
require_relative "./availability.rb"
require_relative "./booking.rb"
require_relative "../string.rb"

module Responses
  class Response
    RESPONSE_TYPE_TO_CLASS_MAP = {
      photographer: "Responses::Photographer",
      availability: "Responses::Availability",
      booking: "Responses::Booking"
    }.freeze

    def initialize(response, response_type)
      @response = response
      @response_type = response_type
    end

    def execute
      data = @response

      if data.is_a? Array
        data.map { |d| build_response(d) }
      else
        build_response(data)
      end
    end

    def build_response(content)
      RESPONSE_TYPE_TO_CLASS_MAP[@response_type.to_sym].constantize.new(content)
    end
  end
end
