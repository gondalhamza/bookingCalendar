require 'json'

module Loader
  class InputData
    def self.call(filename)
      new(filename).call
    end

    def initialize(filename)
      @filename = filename
    end

    def call
      file = File.read(@filename)
      data_hash = JSON.parse(file)
    end
  end
end
