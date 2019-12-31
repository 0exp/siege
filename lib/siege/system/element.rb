# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Element
  require_relative 'element/status'

  # @return [Siege::System::Loader]
  #
  # @api private
  # @since 0.1.0
  attr_reader :loader

  # @param loader [Siege::System::Loader]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(loader)
    @loader = loader
    @lock = Siege::Core::Lock.new
    @status = Siege::System::Element::Status.new(@lock)
  end

  private

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
