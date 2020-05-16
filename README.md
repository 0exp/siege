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

# Usage

- [Modular Application Skeleton](#siegesystem)
- [Generic Instrumenter](#siegetoolinginstrumentation)


---

## Siege::System

Application-wide infrastructure service that incapsulates the core functionality of your system.

```yaml
# database.yml
host: localhost
```

```ruby
class Infrastructure < Siege::System
  element(:database) do
    configuration do
      setting :db_config
      setting :db_address
      values_file 'database.yml'
    end

    init { require 'sequel'; register(:database, Sequel.build_connection(config['host']) } }
    start { database.connect! }
    stop { database.disconnect! }

    after_init { puts '[database] initialized' }
    after_start { puts '[database] started' }
    after_stop { puts '[database] stopped' }

    # before_init {}
    # before_start {}
    # before_stop {}
  end

  element(:logger) do
    init { require 'logger' }
    start { register(:logger, Logger.new(STDOUT) } }
    stop { logger.info('[logger] stopped') }
  end
end

# instantiate with initial configs
app_instance = Infrastructure.build_instance do |settings|
  # hash-based configuration is supported too
  settings.configure(:database, { db_address: '1.2.3.4' }) do |config|
    config.db_address = '127.0.0.1'
  end
end
# => #<Infrastructure:0x00007f81884d7310>

# runtime configuration
app_instance.configure(:database) do |config|
  config.db_address = '5.5.5.5'
end

# hash-based configs
app_instance.configure(:database, { db_address: '7.7.7.7' }) do |config|
  # and etc...
end
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

app_instance = Application.build_instance # => #<Application:0x00007f0f0f1d6332>
```

You can use one element entity from another:
  - if required element has not being started yet - it will be started;
  - you can provde `as:` option with the name of the custom access method (element entity's name is used by default);
  - the element entity name is a string with two parts separated by `.`-symbol: `element_name.entity_name`;

```ruby
class Infrastructure < Siege::System
  element(:database) do
    init do
      use 'logging.logger', as: :log # .log
      use 'alerts.notifier' # .notifier

      log.info('test')
      notifier.call('notification')
    end
  end

  element(:logging) do
    init {}
    start { register(:logger, Logger.new(STDOUT)) } # entity registration
  end

  element(:alerts) do
    init { register(:notifier, Notifier.new) } # entity registration
  end
end

app_instance = Infrastructure.build_instance

app_instance.init(:database)
app_instance.status
# =>
{ 'database' => :initialized, 'logging' => :started, 'alerts' => :started }
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

# Siege::Tooling::Instrumentation

- Usage

```ruby
instrumenter = Siege::Tooling::Instrumentation.build_instance

# --- subscribe ---
subscriber1 = instrumenter.subscribe('*') do |event|
  # some logic
end

subscriber2 = instrumenter.subscribe('user.#') do |event|
  # some logic
end

subscriber3 = instrumenter.subscribe('user.created') do |event|
  # some logic
end

# --- instrument ---
instrumenter.instrument('user.created') do |payload:, metadata:|
  payload[:user_id] = 12345
  metadata[:framework] = 'ActiveRecord'
  # - subscriber1
  # - subscriber2
  # - subscriber3
end

instrumenter.instrument('user.updated') do |payload:, metadata:|
  # - subscriber1
  # - subscriber2
end

instrumenter.instrument('system.fail') do |payload:, metadata:|
  payload[:module] = 'logger'
  # - subscriber1
end

# --- unsubscribe ---
instrumenter.unsubscribe(subscriber1)
instrumenter.unsubscribe(subscriber2)
instrumenter.unsubscribe(subscriber3)
```

- Event Structure (`Siege::Tooling::Instrumentation::Event`)

```ruby
event.id # => UUID
event.name # => user.created (for example)
event.start_time # an instance of Time
event.end_time # an instance of Time
event.payload # initialized during instrumentation
event.metadata # initialized during instrumentation

event.to_h # => { id: ?, name: ?, start_time: ?, end_time: ?, payload: ?, metadata: ? }
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
