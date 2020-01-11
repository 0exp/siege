# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Loader::InvocationContext
  # @param system [Siege::System]
  # @param element [Siege::System::Element]
  # @param loader [Siege::System::Loader]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(system, element, loader)
    @____system____  = system
    @____element____ = element
    @____loader____  = loader
  end

  # @return [Qonfig::DataSet]
  #
  # @api private
  # @since 0.1.0
  def config
    ____loader____.config
  end

  # @param element_entity_path [String]
  # @option as [NilClass, String, Symbol]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def use(element_entity_path, as: nil)
    Siege::System::Element::NameGuard.path_parts_for(element_entity_path) in { entity: entity }
    ____system____[element_entity_path] # resolving validation emulation
    access_method = as.nil? ? entity : as.to_s
    define_singleton_method(access_method) { ____system____[element_entity_path] }
  end

  # @param entity_name [String, Symbol]
  # @param entity_value [Any]
  # @param dynamic_entity_value [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def register(entity_name, entity_value, &dynamic_entity_value)
    entity_name = Siege::System::Element::NameGuard.indifferently_accesable_name(entity_name)
    # TODO:
    #   - []= for explicit entity_value
    #   - .register() {} for dynamic entity value with memoized behaviour by default
    ____element____[entity_name] = entity_value
    define_singleton_method(entity_name) { ____element____[entity_name] }
  end

  # @since 0.1.0
  alias_method :____instance_eval____, :instance_eval

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

  # @return [Siege::System::Loader]
  #
  # @api private
  # @since 0.1.0
  attr_reader :____loader____
end
