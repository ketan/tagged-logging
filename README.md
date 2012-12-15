# TaggedLogging [![Build Status](https://travis-ci.org/ketan/tagged-logging.png?branch=master)](https://travis-ci.org/ketan/tagged-logging)

The rails tagged logger is awesome, but it's only available in rails. This gem makes it available for non-rails applications

## Installation

Add this line to your application's Gemfile:

    gem 'tagged_logging'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tagged_logging

## Usage

```{ruby}
    class MyApplication
      include TaggedLogging
      push_tags(MyApplication, Process.pid)

      def initialize
        info('Initializing application')
      end

      def perform
        tagged("Perform") do
          info("performing some task")
        end
      end

      at_exit do
        info('Exiting application')
      end
    end

    app = MyApplication.new
    app.perform
```

The above will print the following:

    [2012-12-15T14:52:10+05:30] - INFO - [MyApplication] [11321] - Initializing application
    [2012-12-15T14:52:10+05:30] - INFO - [MyApplication] [11321] [Perform] - performing some task
    [2012-12-15T14:52:10+05:30] - INFO - [MyApplication] [11321] - Exiting application

If you'd rather prefer to not pollute your class with the logger methods:
```{ruby}
  class MyApplication
    class MyLogger
      include TaggedLogging
    end

    class <<self
      attr_accessor :logger
    end

    def logger
      self.class.logger
    end

    self.logger = MyLogger
    logger.push_tags(MyApplication, Process.pid)

    def initialize
      logger.info('Initializing application')
    end

    def perform
      logger.tagged("Perform") do
        logger.info("performing some task")
      end
    end

    at_exit do
      logger.info('Exiting application')
    end
  end

  app = MyApplication.new
  app.perform
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# License

MIT License (see the LICENSE file)
