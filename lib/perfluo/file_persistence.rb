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
    attr_reader :memo

    def initialize(memory_file)
      @memory_file = memory_file
      @memo = read_memo
    end

    def save!
      File.open(memory_file, 'w') do |fd|
        fd.write(YAML.dump(self.memo))
      end
    end

    protected
      def read_memo
        return YAML.safe_load(IO.read(memory_file), [Symbol])
      rescue StandardError
        {}
      end
  end
end
