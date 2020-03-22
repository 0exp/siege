# frozen_string_literal: true

# @api private
# @since 0.1.0
module Siege::Tooling::Instrumentation::EventProcessor
  class << self
    # @param event [String]
    # @param payload [Hash]
    # @param metadata [Hash]
    # @param logic [Proc]
    # @return [Siege::Tooling::Instrumentation::Event]
    #
    # @api private
    # @since 0.1.0
    def process_event(event, payload, metadata, logic)
      prevent_incompatabilities!(event, payload, metadata)
      instrument(event, payload, metadata, logic)
    end

    private

    # @param event [String]
    # @param payload [Hash]
    # @param metadata [Hash]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def prevent_incompatabilities!(event, payload, metadata)
      unless event.is_a?(::String)
        raise(Siege::Tooling::Instrumentation::ArgumentError, <<~ERROR_MESSAGE)
          Event name should be a type of String
        ERROR_MESSAGE
      end

      unless payload.is_a?(::Hash)
        raise(Siege::Tooling::Instrumentation::ArgumentError, <<~ERROR_MESSAGE)
          Event payload should be a type of Hash
        ERROR_MESSAGE
      end

      unless metadata.is_a?(::Hash)
        raise(Siege::Tooling::Instrumentation::ArgumentError, <<~ERROR_MESSAGE)
          Event metadata should be a type of Hash
        ERROR_MESSAGE
      end
    end

    # @param event [String]
    # @param payload [Hash]
    # @param metadata [Hash]
    # @param logic [Proc]
    # @return [Siege::Tooling::Instrumentation::Event]
    #
    # @api private
    # @since 0.1.0
    def instrument(event, payload, metadata, logic)
      if logic
        start_time = Siege::Core::Timings.current_time
        logic.call(payload: payload, metadata: metadata)
        end_time = Siege::Core::Timings.current_time
      else
        start_time = end_time = Siege::Core::Timings.current_time
      end

      Siege::Tooling::Instrumentation::Event::Factory.create(
        name: event,
        payload: payload,
        metadata: metadata,
        start_time: start_time,
        end_time: end_time
      )
    end
  end
end
