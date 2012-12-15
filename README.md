# TaggedLogging [![Build Status](https://travis-ci.org/ketan/tagged-logging.png?branch=master)](https://travis-ci.org/ketan/tagged-logging)

The rails tagged logger is awesome, but it's only available in rails. This gem makes it available for non-rails applications.

## Installation

Add this line to your application's Gemfile:

    gem 'tagged_logging'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tagged_logging

## Usage

```{ruby}
    logger = TaggedLogging.new(Logger.new(STDERR))

    logger.tagged('MyApplication', Process.pid) do |l|
      l.debug 'Initializing application'

      tagged("Perform") do
        info("performing some task")
      end
    end
```

The above will print the following:

    [2012-12-15T14:52:10+05:30] - INFO - [MyApplication] [11321] - Initializing application
    [2012-12-15T14:52:10+05:30] - INFO - [MyApplication] [11321] [Perform] - performing some task

You can also push and pop tags as required to the same effect

```{ruby}
    logger = TaggedLogging.new(Logger.new(STDERR))

    logger.push_tags('MyApplication', Po)
      l.debug 'Initializing application'

      tagged("Perform") do
        info("performing some task")
      end
    end
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# License

MIT License (see the LICENSE file)
