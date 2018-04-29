module Perfluo
  class NullOutput
    attr_reader :content

    def initialize
      @content = nil
    end

    def puts(s)
      @content = [@content, s].compact.join("\n")
    end
  end
end
