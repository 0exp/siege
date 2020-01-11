# frozen_string_literal: true

# @api private
# @since 0.1.0
module Siege::System::Loader::DSL::Commands
  require_relative 'commands/abstract'
  require_relative 'commands/init'
  require_relative 'commands/start'
  require_relative 'commands/stop'
  require_relative 'commands/before_init'
  require_relative 'commands/after_init'
  require_relative 'commands/before_start'
  require_relative 'commands/after_start'
  require_relative 'commands/before_stop'
  require_relative 'commands/after_stop'
end
