# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::Tooling::Instrumentation
  require_relative 'instrumentation/errors'
  require_relative 'instrumentation/factory'
  require_relative 'instrumentation/event'
  require_relative 'instrumentation/event_matcher'
  require_relative 'instrumentation/event_processor'
  require_relative 'instrumentation/subscriber'
  require_relative 'instrumentation/subscriber_list'
  require_relative 'instrumentation/notifier'

  class << self
    # @return [Siege::Tooling::Instrumentation]
    #
    # @api public
    # @since 0.1.0
    def build_instance
      Siege::Tooling::Instrumentation::Factory.create
    end
  end

  # @param notifier [Siege::Tooling::Instrumentation::Notifier]
  # @param subscribers [Siege::Tooling::Instrumentation::SubscriberList]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(notifier, subscribers)
    @notifier = notifier
    @subscribers = subscribers
  end

  # @param event_pattern [String]
  # @param listener [Block]
  # @return [Siege::Tooling::Instrumentation::Subscriber]
  #
  # @api private
  # @since 0.1.0
  def subscribe(event_pattern, &listener)
    Subscriber::Factory.create(event_pattern, listener).tap do |subscriber|
      subscribers.add_subscriber(subscriber)
    end
  end

  # @param subscriber [Siege::Tooling::Instrumentation::Subscriber]
  # @return [Siege::Tooling::Instrumentation::Subscriber, NilClass]
  #
  # @api private
  # @since 0.1.0
  def unsubscribe(subscriber)
    subscriber.tap { subscribers.remove_subscriber }
  end

  # @param event_pattern [String]
  # @option payload [Hash]
  # @option metadata [Hash]
  # @param logic [Block]
  # @return [Siege::Tooling::Instrumentation::Event]
  #
  # @api private
  # @since 0.1.0
  # rubocop:disable Layout/LineLength
  def instrument(event_pattern, payload: Event::NO_PAYLOAD.dup, metadata: Event::NO_METADATA.dup, &logic)
    EventProcessor.process_event(event_pattern, payload, metadata, logic).tap do |event|
      notifier.notify(event)
    end
  end
  # rubocop:enable Layout/LineLength

  private

  # @return [Siege::Tooling::Instrumentation::Notifier]
  #
  # @api private
  # @since 0.1.0
  attr_reader :notifier

  # @return [Siege::Tooling::Instrumentation::SubscriberList]
  #
  # @api private
  # @since 0.1.0
  attr_reader :subscribers
end
