require 'time'
module TaggedLogging
  class Formatter < ::Logger::Formatter

    FORMAT = "[%s] - %4s - %s - %s\n"

    def call(severity, time, progname, msg)
      str = case msg
            when ::String
              msg
            when ::Exception
              "#{ msg.message } (#{ msg.class })\n    | " <<
                (msg.backtrace || []).join("\n    | ")
            else
              msg.inspect
            end
      FORMAT % [format_datetime(time), severity, tags_text, msg]
    end

    def push_tags(*tags)
      tags.flatten.reject(&:blank?).tap do |new_tags|
        current_tags.concat new_tags
      end
    end

    def pop_tags(size = 1)
      current_tags.pop size
    end

    def clear_tags!
      current_tags.clear
    end

    def current_tags
      Thread.current[:__tagged_logging_current_tags] ||= []
    end

    def tags_text
      tags = current_tags
      if tags.any?
        tags.collect { |tag| "[#{tag}] " }.join.strip
      end
    end

    private
    def format_datetime(time)
      if @datetime_format.nil?
        time.iso8601
      else
        time.strftime(@datetime_format)
      end
    end
  end
end
