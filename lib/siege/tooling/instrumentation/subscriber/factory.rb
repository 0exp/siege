# frozen_string_literal: true

# @api private
# @since 0.1.0
module Siege::Tooling::Instrumentation::Subscriber::Factory
  class << self
    # @param event [String]
    # @param listener [Proc]
    # @return [Siege::Tooling::Instrumentation::Subcriber]
    #
    # @api private
    # @since 0.1.0
    def create(event, listener)
      prevent_attribute_incompatability(event, listener)
      build_subscriber(event, listener)
    end

    private

    # @param event [String]
    # @param listener [Proc, #call]
    # @return [void]
    #
    # @api private
    # @ssince 0.1.0
    def prevent_attribute_incompatability(event, listener)
      unless event.is_a?(String)
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

    # @param event [String]
    # @param listener [Proc]
    # @return [Siege::Tooling::Instrumentation::Subcriber]
    #
    # @api private
    # @since 0.1.0
    def build_subcriber(event, listener)
      listener = Siege::Tooling::Instrumentation::Subcriber::Listener.new(listener)
      Siege::Tooling::Instrumentation::Subscriber.new(event, listener)
    end
  end
end
