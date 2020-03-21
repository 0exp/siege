# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::Tooling::Instrumentation::Subscriber
  require_relative 'subscriber/factory'
  require_relative 'subscriber/listener'

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  attr_reader :observable_event

  # @param observable_event [String]
  # @param listener [Siege::Tooling::Instrumentation::Subscriber::Listener]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(observable_event, listener)
    @observable_event = observable_event
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

  # @return listener [Siege::Tooling::Instrumentation::Subscriber::Listener]
  #
  # @api private
  # @since 0.1.0
  attr_reader :listener
end
