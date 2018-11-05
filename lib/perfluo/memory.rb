# frozen_string_literal: true

require_relative 'file_persistence'
module Perfluo
  module Memory
    def memo
      persistence.memo
    end

    def persistence
      @persistence ||= NullPersistence.new
    end

    def persistence=(p)
      @persistence = p
    end

    def remember_that?(algo)
      n = flags[algo]
      n && (n == 0 ? nil : n)
    end

    def remember_that!(algo)
      flags[algo] ||= 0
      flags[algo] += 1
    end

    private

      def flags
        memo['flags'] ||= {}
        memo['flags']
      end
  end
end
