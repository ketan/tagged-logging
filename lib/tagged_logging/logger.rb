require 'logger'
require 'tagged_logging/formatter'

module TaggedLogging

  def self.new(logger)
    logger.formatter = TaggedLogging::Formatter.new
    logger.extend(self)
  end

  [:push_tags, :pop_tags, :clear_tags!].each do |method_name|
    define_method(method_name) do |*args, &block|
      formatter.send(method_name, *args, &block)
    end
  end

  def tagged(*tags)
    formatter.tagged(*tags) { yield(self) }
  end

  def flush
    clear_tags!
    super if defined?(super)
  end
end
