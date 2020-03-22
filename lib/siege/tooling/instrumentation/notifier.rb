# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::Tooling::Instrumentation::Notifier
  # @param subscribers [Siege::Toolig::Instrumentation::SubscriberList]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(subscribers)
    @subscribers = subscribers
  end

  # @param event [Siege::Tooling::Instrumentation::Event]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def notify(event)
    subscribers.each do |subscriber|
      subscriber.call(event) if subscriber.listen?(event)
    end
  end

  private

  # @return [Siege::Toolig::Instrumentation::SubscriberList]
  #
  # @api private
  # @since 0.1.0
  attr_reader :subscribers
end
