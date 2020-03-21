# frozen_string_literal: true

class Siege::Tooling::Instrumentation
  # @api public
  # @since 0.1.0
  Error = Class.new(Siege::Tooling::Error)

  # @api public
  # @since 0.1.0
  ArgumentError = Class.new(Siege::Tooling::ArgumentError)
end
