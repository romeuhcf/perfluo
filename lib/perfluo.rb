require "perfluo/version"
require "perfluo/memory"
require "perfluo/listen_trigger"
require "perfluo/output"
require "perfluo/brain"
module Perfluo

  class Bot
    include Memory
    include Output
    include Brain

    def initialize
      @listen_triggers = []
    end

    def listen(matchers, options={}, &block)
      @listen_triggers << ListenTrigger.new(self, matchers, options, &block)
    end
  end
end
