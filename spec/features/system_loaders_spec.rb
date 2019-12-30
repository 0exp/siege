# frozen_string_literal: true

RSpec.describe 'System Loaders' do
  specify 'Raw creation of a simple loader' do
    stub_const('LoggingModule', Class.new(Siege::System::Loader::Abstract) do
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
    end)

    LoggingModule.build
  end
end
