# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Element
  require_relative 'element/name_guard'
  require_relative 'element/entity_registry'
  require_relative 'element/factory'

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
    @name     = Siege::System::Element::NameGuard.indifferently_accesable_name(name)
    @lock     = Siege::Core::Lock.new
    @entities = Siege::System::Element::EntityRegistry.new
    @loader   = loader
  end

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def init!; end

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def start!; end

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def end!; end

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def reload!; end

  private

  # @return [Siege::System::Element::EntityRegistry]
  #
  # @api private
  # @sinec 0.1.0
  attr_reader :entities

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
