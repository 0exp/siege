# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Loader::InvocationContext
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(system, element)
    @____system____  = system
    @____element____ = element
  end

  # @param element_entity_path
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def import(element_entity_path, as: nil)
    Siege::System::Element::NameGuard.path_parts_for(element_entity_path) in { entity: entity }
    ____system____[entity] # resolving validation emulation
    access_method = as.nil? ? entity : as
    instrument_shadowed_methods(access_method)
    define_singleton_method(access_method) { ____system____[entity] }
  end

  # @param entity_name [String, Symbol]
  # @param entity_value [Any]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def register(entity_name, entity_value)
    entity_name = Siege::System::Element::NameGuard.indifferently_accesable_name(entity_name)
    ____element____[entity_name] = entity_value
    instrument_shadowed_methods(access_method)
    define_singleton_method(entity_name) { ____element____[entity_name] }
  end

  private

  # @since 0.1.0
  alias_method :____singleton_methods____, :singleton_methods

  # @return [Siege::System]
  #
  # @api private
  # @since 0.1.0
  attr_reader :____system____

  # @return [Siege::System::Element]
  #
  # @api private
  # @since 0.1.0
  attr_reader :____element____

  # @param shadowing_method [String]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def instrument_shadowed_methods(shadowing_method)
    # TODO: instrumentation layer
    ::Kernel.warn(
      "[Siege::System] Shadowing of previously registered/imported dependency :#{shadowing_method}"
    ) if ____singleton_methods____.include?(shadowing_method.to_sym)
  end
end
