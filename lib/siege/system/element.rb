# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Element
  require_relative 'element/name_guard'

  # @return name [String]
  #
  # @api private
  # @since 0.1.0
  attr_reader :name

  # @return [Siege::System::Loader]
  #
  # @api private
  # @since 0.1.0
  attr_reader :loader

  # @param name [String]
  # @param loader [Siege::System::Loader]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(name, loader)
    @name = Siege::System::Element::NameGuard.indifferently_accesable_name(name)
    @loader = loader
    @lock = Siege::Core::Lock.new
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
