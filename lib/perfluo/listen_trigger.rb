module Perfluo
  class ListenTrigger

    attr_reader :block, :matchers
    def initialize(subject, matchers, options, &block)
      @subject = subject
      @matchers = [ matchers ].flatten.compact
      @block = block
      @mode = options.delete(:case) || :any
      raise ArgumentError, "unexpected options '#{options.keys.join(', ')}'" unless options.empty?
    end

    def match?(msg)
      _m = @matchers.send("#{@mode}?") do |matcher|
        self.send("match_trigger_#{matcher.class.name.downcase}?", matcher, msg)
      end

      if _m
        return true
      else
        return false
      end
    end

    def match_trigger_regexp?(matcher, msg)
      msg =~ matcher
    end

    def match_trigger_string?(matcher, msg)
      msg == matcher # TODO decide how to match strings
    end
  end
end

