# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::DSL::Commands::Definition::Element < Siege::System::DSL::Commands::Abstract
  # @since 0.1.0
  self.inheritable = true

  # @param element_name [String, Symbol]
  # @param loader_klass [Class<Siege::System::Loader>, NilClass]
  # @param loader_definition [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(element_name, loader_klass, loader_definition)
    prevent_incompatabilities!(element_name, loader_klass, loader_definition)

    @element_name = Siege::System::Element::NameGuard.indifferently_accesable_name(element_name)
    @loader_klass = loader_klass
    @loader_definition = loader_definition
  end

  # @param system_instance [Siege::System]
  # @param system_elements [Siege::Core::Container]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def call(system_instance, system_elements)
    element = Siege::System::Element::Factory.create(element_name, loader_klass, loader_definition)
    system_elements.register(element_name) { element }
  end

  private

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  attr_reader :element_name

  # @return [Siege::System::Loader, NilClass]
  #
  # @api private
  # @sinc 0.1.0
  attr_reader :loader_klass

  # @return [Proc]
  #
  # @api private
  # @since 0.1.0
  attr_reader :loader_definition

  # @param element_name [String, Symbol]
  # @param loader [Siege::System::Loader, NilClass]
  # @param loader_definition [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def prevent_incompatabilities!(element_name, loader, loader_definition)
    Siege::System::Element::NameGuard.prevent_incomparabilities!(element_name)

    raise(
      Siege::System::ArgumentError,
      'System Loader should be a class inherited from Siege::System::Loader'
    ) if !loader.nil? && !loader.is_a?(Class) && !(loader <= Siege::System::Loader)

    raise(
      Siege::System::ArgumentError,
      'System Loader object/definition is not provided'
    ) if loader.nil? && loader_definition.nil?

    raise(
      Siege::System::AmbiguousElementDefinitionError,
      'You should privde a loader definitions OR a loader object (not a both)'
    ) if !loader.nil? && !loader_definition.nil?
  end
end
