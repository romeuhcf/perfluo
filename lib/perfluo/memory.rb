require_relative 'json_persistence'
module Perfluo
  module Memory
    def memo
      persistence.memo
    end

    def persistence
      @persistence ||= JsonPersistence.new('persistence.json')
    end

     def persistence=(p)
       @persistence = p
     end
=begin
    def listened
      memo['listened']||=[]
    end

    def last_listened_msg
      memo['listened']||=[]
      memo['listened'].last
    end
=end
        def remember_that?(algo)
      n = flags[algo]
      n && (n == 0 ? nil : n)
    end

    def remember_that!(algo)
      flags[algo]||=0
      flags[algo]+=1
    end
    private
    def flags
      memo['flags']||= {}
      memo['flags']
    end


  end
end
