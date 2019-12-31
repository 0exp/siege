# frozen_string_literal: true

# @api public
# @since 0.1.0
class Siege::Core::Lock
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @mutex = Mutex.new
  end

  # @param block [Block]
  # @return [Any]
  #
  # @api public
  # @since 0.1.0
  def synchronize(&block)
    mutex.owned? ? yield : mutex.synchronize(&block)
  end

  private

  # @return [Mutex]
  #
  # @api private
  # @since 0.1.0
  attr_reader :mutex
end
