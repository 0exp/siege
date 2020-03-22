# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::Tooling::Instrumentation::SubscriberList
  # @since 0.1.0
  include Enumerable

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @list = []
    @lock = Siege::Core::Lock.new
  end

  # @param [Siege::Tooling::Instrumentation::Subscriber]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add_subscriber(subscriber)
    thread_safe { list.push(subscriber) }
  end

  # @param [Siege::Tooling::Instrumentation::Subscriber]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def remove_subscriber(subscriber)
    thread_safe { list.delete(subscriber) }
  end

  # @param block [Block]
  # @yield [subscriber]
  # @yieldparam subscriber [Siege::Tooling::Instrumentation::Susbcriber]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def each(&block)
    block_given? ? list.each(&block) : list.each
  end

  private

  # @return [Array<Siege::Tooling::Instrumentation::Subscriber>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :list

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
