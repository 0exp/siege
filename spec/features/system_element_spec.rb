# frozen_string_literal: true

RSpec.describe 'System Element' do
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

    # NOTE: build loader
    loader = LoggingLoader.build

    # NOTE: build inherited loader
    sub_loader = SubLoggingLoder.build

    # NOTE: build simple element
    element = Siege::System::Element.new('logging', loader)

    sub_element = Siege::System::Element.new('sub_logging', sub_loader)
  end

  specify 'Complex system definition' do
    stub_const('Application', Class.new(Siege::System) do
      element(:database) do
        init { puts 'init!' }
        start { puts 'start!' }
        stop { puts 'stop!' }
      end
    end)
  end
end
