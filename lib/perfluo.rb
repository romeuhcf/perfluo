require "perfluo/version"
require "perfluo/memory"
require "perfluo/listen_trigger"
require "perfluo/output"
require "perfluo/brain"

module Perfluo
  SELF_CONTEXT_NAME = 'self'
  class Subject
    attr_accessor :bot, :parent

    def initialize(parent = nil)
      self.parent = parent
    end

    def to_s
      "#<#{self.class.name}:#{self.name}@#{self.current_subject_name}>"
    end

    def listen_triggers
      @listen_triggers ||= []
    end

    def name=(name)
      @_subject_name = name
    end

    def name
      @_subject_name ||= SELF_CONTEXT_NAME
    end

    def listen(matchers, options={}, &block)
      self.listen_triggers << ListenTrigger.new(self, matchers, options, &block)
    end

    def about(subject_name, &block)
      Subject.new(self).tap do |subject|
        subject.name = subject_name
        subject.bot = self.bot
        subject.instance_exec &block
        bot.register_subject(subject)
      end
    end

    def enter(&block)
      @on_enter = block
    end

    %w[enter leave return].each do |moment|
      define_method "trigger_#{moment}"  do
        hook = instance_variable_get("@on_#{moment}")
        instance_exec( &hook) if hook
      end
    end


    def root?
      parent.nil?
    end

    def path
      if root?
        '/'
      else
        File.join(parent.path , self.name)
      end
    end

    def current_subject_path
      current_subject.path
    end

    def react_to_listen_on_subject(msg)
      self.listen_triggers.each do |trigger|
        if trigger.match?(msg)
          self.instance_exec(msg, &trigger.block)
          break
        end
      end
    end

    def method_missing(mname, *margs, &mblock)
      if bot.respond_to?(mname)
        bot.send(mname, *margs, &mblock)
      else
        super
      end
    end
  end
end

module Perfluo

  class ContextManager
    attr_reader :bot
    def initialize(bot)
      @bot = bot
    end

    def current_subject_path
      current_subject.path
    end

    def current_subject_name
      current_subject.name
    end

    def current_subject
      subjects_stack.last
    end

    def subjects_stack
      @_subjects_stack ||= [bot]
    end

    def resolve_subject(subject_or_path)
      if subject_or_path.is_a? String
        resolve_subject_path(subject_or_path)
      else
        subject_or_path
      end
    end

    def resolve_subject_path(path)
      subject_by_path(File.expand_path(path, current_subject.path))
    end

    def subject_by_path(path)
      @subject_by_path.fetch(path)
    end

    def register_subject(subject)
      @subject_by_path ||= {}
      @subject_by_path[subject.path] = subject
    end

    def change_subject(subject_path)
      old_sub = current_subject
      new_sub = resolve_subject(subject_path)

      return unless old_sub != new_sub

      if subject_was_mentioned_earlier = self.subjects_stack.include?(new_sub)
        self.subjects_stack.delete(new_sub)
      end

      self.subjects_stack.push(new_sub)

      if subject_was_mentioned_earlier
        new_sub.trigger_return
      else
        new_sub.trigger_enter
      end

      old_sub.trigger_leave
    end
  end

  class Bot < Subject
    include Memory
    include Output

    def react_to_listen(msg)
      current_subject.react_to_listen_on_subject(msg)
    end

    def bot
      self
    end

    def context_manager
      @_context_manager||= ContextManager.new(self)
    end

    def current_subject
      context_manager.current_subject
    end

    def setup(&block)
      instance_exec(&block)
    end

    def change_subject(to)
      context_manager.change_subject(to)
    end

    def register_subject(subject)
      context_manager.register_subject(subject)
    end

    def subjects_stack
      context_manager.subjects_stack.map(&:path)
    end

    def save!
      persistence.save!
    end
  end
end
