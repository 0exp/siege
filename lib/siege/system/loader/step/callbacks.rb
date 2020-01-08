# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Loader::Step::Callbacks
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @lock = Siege::Core::Lock.new
    @callbacks = []
  end

  # @param callback [Siege::System::Loader::Step::Callback]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add(callback)
    thread_safe { callbacks.push(callback) }
  end

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def call
    thread_safe { callbacks.each(&:call) }
  end

  private

  # @return [Array<Siege::System::Loader::Step::Callback>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :callbacks

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
