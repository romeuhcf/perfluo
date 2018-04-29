require 'json'
module Perfluo
  class JsonPersistence
    attr_accessor :memory_file
    def initialize(memory_file)
      @memory_file = memory_file
    end

    def memo
      @_memo ||= begin
                   File.open(memory_file, 'r') do |fd|
                     JSON.parse(fd.read)
                   end
                 rescue
                   {}
                 end
    end

    def save!
      File.open(memory_file, 'w') do |fd|
        fd.write(JSON.pretty_generate(memo))
      end
    end


  end
end

