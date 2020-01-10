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

app_instance = Infrastructure.build # => #<Infrastructure:0x00007f81884d7310>
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

app_instance = Application.build # => #<Application:0x00007f0f0f1d6332>
```

Resolve registered element entities (you should provide both element name and entity name):

```ruby
class Infrastructre < Siege::System
  element(:database) do
    init { register(:db) { DBClient.new } }
  end

  element(:logging) do
    start { register(:logger) { Logger.new(STDOUT) } }
  end
end

infrastructure = Infrastructre.build_instance

infrastructure.init
infrastructure['database.db'] # => #<DBClient:0x00007f1f991d7701>

infrastructure.start(:logger)
infrastructure['logging.logger'] # => #<Logger:0x00007f1f991d7702>

# All registered entities:
infrastructure.entities
# =>
{
  'database.db' => #<DBClient:0x00007f1f991d7701>,
  'logging.logger' => #<Logger:0x00007f1f991d7702>
}
```

System's Initialization/Starting/Stopping processes:

```ruby
app_instance.init # initialize all elements
app_instance.init(:logger) # initialize logger element

app_instance.status
# =>
{ 'logger' => :initialized, 'database' => :non_initialized }

app_instance.start # start all elements
app_instance.start(:logger, :database) # start only the logger element

app_instance.status
# =>
{ 'logger' => :started, 'database' => :started }

# and stop / stop(*element_names) respectively
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
