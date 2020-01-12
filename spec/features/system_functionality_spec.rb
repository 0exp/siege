# frozen_string_literal: true

RSpec.describe 'System functionality' do
  specify 'Raw creation of a simple system element' do
    # NOTE: create loader
    stub_const('LoggingLoader', Class.new(Siege::System::Loader) do
      init  { puts '[-initialize-]' }
      start { puts '[-start-]' }
      stop  { puts '[-stop-]' }

      before_init { puts '[init] first before' }
      before_init { puts '[init] second before' }

      after_init { puts '[init] first after' }
      after_init { puts '[init] seond after' }

      before_start { puts '[start] first before' }
      before_start { puts '[start] second before' }

      after_start { puts '[start] first after' }
      after_start { puts '[start] seond after' }

      before_stop { puts '[stop] first before' }
      before_stop { puts '[stop] second before' }

      after_stop { puts '[stop] first after' }
      after_stop { puts '[stop] seond after' }

      # NOTE: this is not a RSpec hook (create pool request to rubocop-rspec)
      # rubocop:disable RSpec/EmptyLineAfterHook
      before(:init)  { puts '[init] more convinient way' }
      before(:start) { puts '[init] more convinient way' }
      before(:stop)  { puts '[init] more convinient way' }
      after(:init)  { puts '[init] more convinient way' }
      after(:start) { puts '[init] more convinient way' }
      after(:stop)  { puts '[init] more convinient way' }
      # rubocop:enable  RSpec/EmptyLineAfterHook
    end)

    # NOTE: loader inheritance
    stub_const('SubLoggingLoder', Class.new(LoggingLoader))
  end

  specify 'Complex system definition' do
    stub_const('LoggingLoader', Class.new(Siege::System::Loader))

    stub_const('Infrastructure', Class.new(Siege::System) do
      element(:database) do # NOTE: define with anonimous loader definitions
        init { puts 'init!' }
        start { puts 'start!' }
        stop { puts 'stop!' }
      end

      element(:logger, loader: LoggingLoader) # NOTE: define with explicit loader klass
    end)

    # NOTE: create instance
    system_instance = Infrastructure.build_instance
  end

  specify 'cross dependent elements' do
    stub_const('Infrastructure', Class.new(Siege::System) do
      element(:database) do
        init { use('logging.logger') }
      end

      element(:logging) do
        start { register(:logger, 'SimpleLogger') }
      end
    end)

    system_instance = Infrastructure.build_instance
    system_instance.init(:database)
  end

  specify 'init/star/stop and status' do
    stub_const('LoggingLoader', Class.new(Siege::System::Loader))

    stub_const('Infrastructure', Class.new(Siege::System) do
      element(:database) do # NOTE: define with anonimous loader definitions
        configuration do
          setting :kek
          setting :pek
        end

        init { register(:db) { 'DataBaseClient' } } # dynamic value registration
        start { puts config.to_h }
        stop { puts db }
      end

      element(:logger, loader: LoggingLoader) # NOTE: define with explicit loader klass

      element(:notifier) do
        configuration do
          setting :client, 'ExceptionNotifier'
        end

        init do
          register(:notifik, (Proc.new {}))
        end

        start do
          use 'database.db', as: :mazafaka
          puts "NOTIFIIER"
          puts config.to_h
          puts mazafaka
        end
      end
    end)

    system_instance = Infrastructure.build_instance do |settings|
      settings.configure(:database, { pek: 'azaza' }) do |config|
        config.kek = 1023123
      end

      settings.configure(:notifier) do |config|
        config.client = 'LoggerNotifier'
      end
    end

    system_instance.configure(:database, { pek: 'pusipusi' }) do |config|
      config.kek = :lel
    end

    system_instance.configure(:notifier) do |config|
      config.client = 'RUNTIME!!!'
    end

    system_instance.init

    system_instance.init
    puts "---\n#{system_instance.status}\----"
    system_instance.start
    puts "---\n#{system_instance.status}\----"
    system_instance.stop
    puts "---\n#{system_instance.status}\----"

    # registered entity
    puts system_instance['database.db']

    # registered_entities
    puts system_instance.entities

    system_instance.start(:notifier)
    puts system_instance.status

    # TODO:
    # system_instance.loading_order
    # system_instance.loading_order=
  end
end
