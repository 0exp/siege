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

  # @param entity_name [String, Symbol]
  # @param entity_value [Any]
  #
  # @api private
  # @since 0.1.0
  def register_entity(entity_name, entity_value)
    entities.register(entity_name) { entity_value }
  end
  alias_method :[]=, :register_entity

  # @param entity_name [String, Symbol]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def get_entity(entity_name)
    entities[entity_name]
  end
  alias_method :[], :get_entity

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  def status
    thread_safe { loader.status_identifier }
  end

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def init!
    thread_safe { loader.init! }
  end

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def start!
    thread_safe { loader.start! }
  end

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def stop!
    thread_safe { loader.stop! }
  end

  private

  # @return [Siege::System::Element::EntityRegistry]
  #
  # @api private
  # @sinec 0.1.0
  attr_reader :entities

  # @return [Siege::System::Loader]
  #
  # @api private
  # @since 0.1.0
  attr_reader :loader

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
