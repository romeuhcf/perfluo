module Perfluo
  class NullOutput
    attr_reader :content

    def initialize
      @content = nil
    end

    def say(s, **extra)
      @content = [@content, s].compact.join("\n")
    end
  end
end

require 'colorize'
module Perfluo
  class TerminalOutput
    def say(s)
      (s.to_s.size / 5).times do
        ell = ['.  ', '.. ', '...', ' ..' , '  .' , '   ', '. .'].sample
        $stdout.write "[Ana está digitando #{ell}]\r".blue
        sleep 0.1
      end
      $stdout.write "                                          \r"
      puts s.green
    end
  end
end
