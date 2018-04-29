require_relative 'null_output'
module Perfluo
  module Output
    def output
      @output ||= NullOutput.new
    end

    def output=(o)
      @output = o
    end

    def say(this)
      [this].flatten.each do |it|
        output.puts it
      end
    end

    def confirm?(prompt, subject)
      prompting subject, :boolean
      say prompt
    end

  end
end
