# frozen_string_literal: true

class Siege::System::Instrumentation
  # @api public
  # @since 0.1.0
  Error = Class.new(Siege::Error)

  # @api public
  # @since 0.1.0
  ArgumentError = Class.new(Siege::ArgumentError)
end
