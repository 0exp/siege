# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::Tooling::Instrumentation::Subscriber
  require_relative 'subscriber/factory'
  require_relative 'subscriber/listener'

  # @param event_matcher [Siege::Tooling::Instrumentation::EventMatcher]
  # @param listener [Siege::Tooling::Instrumentation::Subscriber::Listener]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(event_matcher, listener)
    @event_matcher = event_matcher
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

  # @param event [Siege::Tooling::Instrumentation::Event]
  # @return [Boolean]
  #
  # @api private
  # @sicne 0.1.0
  def listen?(event)
    event_matcher.generic? || event_matcher.match?(event.name)
  end

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  def observable_event
    event_matcher.scope_pattern
  end

  private

  # @return listener [Siege::Tooling::Instrumentation::Subscriber::Listener]
  #
  # @api private
  # @since 0.1.0
  attr_reader :listener

  # @return [Siege::Tooling::Instrumentation::EventMatcher]
  #
  # @api private
  # @sicne 0.1.0
  attr_reader :event_matcher
end
