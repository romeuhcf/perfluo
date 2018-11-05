# frozen_string_literal: true

require 'yaml'
module Perfluo
  class NullPersistence
    def memo
      @_memo ||= {}
    end

    def save!; end
  end

  class FilePersistence
    attr_accessor :memory_file
    def initialize(memory_file)
      @memory_file = memory_file
    end

    def memo
      File.open(memory_file, 'r') do |fd|
        YAML.safe_load(fd.read)
      end
    rescue StandardError
      {}
    end

    def save!
      memo # XXX avoiding false memo for some weird reason
      File.open(memory_file, 'w') do |fd|
        fd.write(YAML.dump(memo))
      end
    end
  end
end
