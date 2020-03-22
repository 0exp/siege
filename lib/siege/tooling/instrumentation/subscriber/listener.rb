# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::Tooling::Instrumentation::Subscriber::Listener
  # @param listener [Proc, #call]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(listener)
    @listener = listener
  end

  # @param event [Siege::Tooling::Instrumentation::Event]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def call(event)
    listener.call(event)
  end

  private

  # @return [Siege::Tooling::Instrumentation::Subscriber::Listener]
  #
  # @api private
  # @since 0.1.0
  attr_reader :listener
end
