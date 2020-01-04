# Siege &middot; [![Gem Version](https://badge.fury.io/rb/siege.svg)](https://badge.fury.io/rb/siege) [![Build Status](https://travis-ci.org/0exp/siege.svg?branch=master)](https://travis-ci.org/0exp/siege)

Software architecture principles realized as a code.

## Installation

```ruby
gem 'siege'
```

```shell
$ bundle install
# --- or ---
$ gem install 'siege'
```

```ruby
require 'siege'
```

---

## Siege::System

Application-wide infrastructure service that incapsulates the core functionality of your system.

```ruby
class Infrastructure < Siege::System
  element(:database) do
    init { require 'sequel'; register(:database) { connection = Sequel.build_connection } }
    start { database.connect! }
    stop { database.disconnect! }

    after_init { puts '[database] initialized' }
    after_start { puts '[database] started' }
    after_stop { puts '[database] stopped' }
  end

  element(:logger) do
    init { require 'logger' }
    start { register(:logger) { Logger.new(STDOUT) } }
    stop { logger.info('[logger] stopped') }
  end
end

app_instance = Infrastructure.create_instance # => #<Infrastructure:0x00007f81884d7310>
```

Custom element loader example:

```ruby
class LoggerLoader < Siege::System::Loader
  init { require 'logger' }
  start { register(:logger) { Logger.new(STDOUT) } }
  stop { logger.info('[logger] stopped') }
end

class Application < Siege::System
  element(:logger, loader: LoggerLoader)
end

app_instance = Application.create_instance # => #<Application:0x00007f0f0f1d6332>
```

---

## Contributing

- Fork it ( https://github.com/0exp/siege/fork )
- Create your feature branch (`git checkout -b feature/my-new-feature`)
- Commit your changes (`git commit -am '[my-new-featre] Add some feature'`)
- Push to the branch (`git push origin feature/my-new-feature`)
- Create new Pull Request

## License

Released under MIT License.

## Authors

[Rustam Ibragimov](https://github.com/0exp)
