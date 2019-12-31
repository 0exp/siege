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

    # NOTE: build loader
    loader = LoggingLoader.build

    # NOTE: build simple element
    element = Siege::System::Element.new(loader)
  end
end
