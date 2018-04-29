module Perfluo
  class ListenTrigger

    attr_reader :block
    def initialize(bot, matchers, options, &block)
      @bot = Bot
      @matchers = [ matchers ].flatten.compact
      @block = block
      @mode = options.delete(:case) || :any
      raise ArgumentError, "unexpected options '#{options.keys.join(', ')}'" unless options.empty?
    end

    def match?(msg)
      @matchers.send("#{@mode}?") do |matcher|
        self.send("match_trigger_#{matcher.class.name.downcase}?", matcher, msg)
      end
    end

    def match_trigger_regexp?(matcher, msg)
      msg =~ matcher
    end
  end
end

