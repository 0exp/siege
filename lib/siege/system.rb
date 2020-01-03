# frozen_string_literal: true

# @api public
# @since 0.1.0
class Siege::System
  require_relative 'system/errors'
  require_relative 'system/loader'
  require_relative 'system/element'
  require_relative 'system/builder'
  require_relative 'system/dsl'

  # @since 0.1.0
  include Siege::System::DSL
end
