# frozen_string_literal: true

# @api private
# @sicne 0.1.0
module Siege::Tooling::Instrumentation::Factory
  class << self
    # @return [Siege::Tooling::Instrumentation]
    #
    # @api private
    # @since 0.1.0
    def create
      subscribers = build_subscribers
      notifier = build_notifier(subscribers)
      build_instrumentation_entity(notifier, subscribers)
    end

    private

    # @return [Siege::Tooling::Instrumentation::SubscriberList]
    #
    # @api private
    # @since 0.1.0
    def build_subscribers
      Siege::Tooling::Instrumentation::SubscriberList.new
    end

    # @param subscribers [Siege::Tooling::Instrumentation::SubscriberList]
    # @return [Siege::Tooling::Instrumentation::Notifier]
    #
    # @api private
    # @since 0.1.0
    def build_notifier(subscribers)
      Siege::Tooling::Instrumentation::Notifier.new(subscribers)
    end

    # @param notifier Siege::Tooling::Instrumentation::Notifier]
    # @param subscribers [Siege::Tooling::Instrumentation::SubscriberList]
    # @return [Siege::Tooling::Instrumentation]
    #
    # @api private
    # @since 0.1.0
    def build_instrumentation_entity(notifier, subscribers)
      Siege::Tooling::Instrumentation.new(notifier, subscribers)
    end
  end
end
