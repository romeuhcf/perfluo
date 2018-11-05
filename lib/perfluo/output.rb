# frozen_string_literal: true

require_relative 'null_output'
module Perfluo
  class Prompt
    def initialize(bot, memo_id, msgs = nil)
      @bot = bot
      @msgs = msgs
      @memo_id = memo_id
    end

    def to_s
      "[Prompt:#{id}]"
    end

    def message(&message)
      @msgs = message
    end

    def options(options = nil)
      @options = options
    end

    def log(*args)
      @bot.log(*args)
    end

    def run
      run_message
    end

    def run_message
      msgs = case @msgs
             when String
               @msgs
             when Array
               @msgs
             when Proc
               instance_exec(&@msgs)
             end

      msgs = [msgs].flatten

      msgs.each_with_index do |msg, index|
        is_last = index == msgs.count - 1
        if is_last && @options
          menu msg, @options
        else
          say msg
        end
      end
    end

    def react_to_listen(msg)
      value = if @_preprocess
                @_preprocess.call(msg)
              else
                msg
              end

      if valid?(value)
        log "React to listen on Prompt #{self} : #{msg} -> valid entry"
        @bot.memo[id] = value
        @bot.mark_as_not_prompting!
        on_success
      else
        log "React to listen on Prompt #{self} : #{msg} -> INvalid entry"
        on_failure
      end
    end

    def id
      @memo_id
    end

    def preprocess(block)
      @_preprocess = block
    end

    def retries(n)
      @retries = n
    end

    def validates(&block)
      @validates = block
    end

    def success(&block)
      @success = block
    end

    def on_success
      instance_exec(&@success) if @success
    end

    def failure(&block)
      @failure = block
    end

    def on_failure
      instance_exec(&@failure) if @failure
    end

    attr_reader :bot

    def method_missing(name, *args, &block)
      if bot.respond_to? name
        bot.send(name, *args, &block)
      else
        super
      end
    end

    protected

      def valid?(_value)
        # TODO
        true
      end
  end

  module Output
    def output
      @output || raise('null output')
    end

    def output=(o)
      @output = o
    end

    def say(this)
      [this].flatten.compact.each do |it|
        output.say it
      end
    end

    def prompt(prompt_id)
      prompt = bot.get_prompt(prompt_id)
      prompt.run
      mark_as_prompting!(prompt)
    end

    def menu(message, options)
      output.menu(message, options)
    end

    def set_prompt(memo_id, msgs = nil, &block)
      prompt = Perfluo::Prompt.new(self, memo_id, msgs)
      prompt.instance_exec(&block)
      bot.register_prompt(prompt)
    end
  end
end
