# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::Tooling::Instrumentation::Event::Factory
  class << self
    # @option name [String]
    # @option payload [Hash]
    # @option metadata [Hash]
    # @option start_time [Time]
    # @option end_time [Time]
    # @return [Siege::Tooling::Instrumentation::Event]
    #
    # @api private
    # @since 0.1.0
    def create(
      name:,
      payload: Siege::Tooling::Instrumentation::Event::NO_PAYLOAD,
      metadata: Siege::Tooling::Instrumentation::Event::NO_METADATA,
      start_time:,
      end_time:
    )
      validate_attributes(name, payload, metadata, start_time, end_time)
      build_event(name, payload, metadata, start_time, end_time)
    end

    private

    # @param name [String]
    # @param payload [Hash]
    # @param metadata [Hash]
    # @param start_time [Time]
    # @param end_time [Time]
    # @return [Siege::Tooling::Instrumentation::Event]
    #
    # @api private
    # @since 0.1.0
    def validate_attributes(name, payload, metadata, start_time, end_time)
      validate_name(name)
      validate_payload(payload)
      validate_metadata(metadata)
      validate_start_time(start_time)
      validate_end_time(end_time)
    end

    # @param name [String]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def validate_name(name)
      unless name.is_a?(::String)
        raise(Siege::Tooling::Instrumentation::ArgumentError, <<~ERROR_MESSAGE)
          Event name should be a type of String
        ERROR_MESSAGE
      end
    end

    # @param payload [Hash]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def validate_payload(payload)
      unless payload.is_a?(::Hash)
        raise(Siege::Tooling::Instrumentation::ArgumentError, <<~ERROR_MESSAGE)
          Event payload should be a type of Hash
        ERROR_MESSAGE
      end
    end

    # @param metadata [Hash]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def validate_metadata(metadata)
      unless metadata.is_a?(::Hash)
        raise(Siege::Tooling::Instrumentation::ArgumentError, <<~ERROR_MESSAGE)
          Event metadata should be a type of Hash
        ERROR_MESSAGE
      end
    end

    # @param start_time [Time]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def validate_start_time(start_time)
      unless start_time.is_a?(::Time)
        raise(Siege::Tooling::Instrumentation::ArgumentError, <<~ERROR_MESSAGE)
          Event start_time should be a type of Time
        ERROR_MESSAGE
      end
    end

    # @param end_time [Time]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def validate_end_time(end_time)
      unless end_time.is_a?(::Time)
        raise(Siege::Tooling::Instrumentation::ArgumentError, <<~ERROR_MESSAGE)
          Event end_time should be a type of Time
        ERROR_MESSAGE
      end
    end

    # @param name [String]
    # @param payload [Hash]
    # @param metadata [Hash]
    # @param start_time [Time]
    # @param end_time [Time]
    # @return [Siege::Tooling::Instrumentation::Event]
    #
    # @api private
    # @since 0.1.0
    def build_event(name, payload, metadata, start_time, end_time)
      Siege::Tooling::Instrumentation::Event.new(
        generate_event_id, name, payload, metadata, start_time, end_time
      )
    end

    # @return [String]
    #
    # @api private
    # @since 0.1.0
    def generate_event_id
      Siege::Core::Randomizer.uuid
    end
  end
end
