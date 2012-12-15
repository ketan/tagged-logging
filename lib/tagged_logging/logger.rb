require 'logger'

module TaggedLogging
  def self.included(receiver)
    receiver.class_eval do
      extend                ClassMethods
      include               InstanceMethods
    end
  end

  module ClassMethods
    def tagged(*new_tags, &block)
      new_tags = push_tags(*new_tags)
      yield(self)
    ensure
      pop_tags(new_tags.size)
    end

    [:push_tags, :pop_tags, :clear_tags!].each do |method_name|
      define_method(method_name) do |*args, &block|
        logger.formatter.send(method_name, *args, &block)
      end
    end

    def logger
      @@logger ||= ::Logger.new(STDOUT).tap do |l|
        l.level = ::Logger::INFO
        l.formatter = ::TaggedLogging::Formatter.new
      end
    end

    def logger=(logger)
      @@logger = logger
    end

    def flush
      clear_tags!
      logger.flush if defined?(logger.super)
    end

    [:debug, :info, :warn, :error, :fatal].each do |method_name|
      define_method(method_name) do |*args, &block|
        self.logger.send(method_name, *args, &block)
      end
    end
  end

  module InstanceMethods
    [:debug, :info, :warn, :error, :fatal].each do |method_name|
      define_method(method_name) do |*args, &block|
        self.class.logger.send(method_name, *args, &block)
      end
    end

    [:tagged, :flush, :logger, :logger=, :push_tags, :pop_tags, :clear_tags!].each do |method_name|
      define_method(method_name) do |*args, &block|
        self.class.send(method_name, *args, &block)
      end
    end
  end
end
