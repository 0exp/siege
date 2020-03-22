# frozen_string_literal: true

# @api private
# @since 0.1.0
module Siege::Tooling::Instrumentation::Subscriber::Factory
  class << self
    # @param event_pattern [String]
    # @param listener [Proc]
    # @return [Siege::Tooling::Instrumentation::Subcriber]
    #
    # @api private
    # @since 0.1.0
    def create(event_pattern, listener)
      prevent_attribute_incompatability(event_pattern, listener)
      build_subscriber(event_pattern, listener)
    end

    private

    # @param event_pattern [String]
    # @param listener [Proc, #call]
    # @return [void]
    #
    # @api private
    # @ssince 0.1.0
    def prevent_attribute_incompatability(event_pattern, listener)
      unless event_pattern.is_a?(String)
        raise(Siege::Tooling::Instrumentation::ArgumentError, <<~ERROR_MESSAGE)
          Instrumented Event should be a type of string
        ERROR_MESSAGE
      end

      unless listener.is_a?(Proc)
        raise(Siege::Tooling::Instrumentation::ArgumentError, <<~ERROR_MESSAGE)
          Event listener should be a #call-able project
        ERROR_MESSAGE
      end
    end

    # @param event_pattern [String]
    # @param listener [Proc]
    # @return [Siege::Tooling::Instrumentation::Subcriber]
    #
    # @api private
    # @since 0.1.0
    def build_subscriber(event_pattern, listener)
      listener = Siege::Tooling::Instrumentation::Subscriber::Listener.new(listener)
      event_matcher = Siege::Tooling::Instrumentation::EventMatcher.new(event_pattern)
      Siege::Tooling::Instrumentation::Subscriber.new(event_matcher, listener)
    end
  end
end
