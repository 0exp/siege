# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::DSL::Commands::Element < Siege::System::DSL::Commands::Abstract
  # @param name [String, Symbol]
  # @param loader [Siege::System::Loader, NilClass]
  # @param loader_definition [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(name, loader, loader_definition)
    prevent_incompatabilities!(name, loader, loader_definition)

    @name = Siege::System::Element::NameGuard.indifferently_accesable_name(name)
    @loader = loader
    @loader_definition = loader_definition
  end

  # @param system_elements [Siege::Core::Container]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def call(system_elements); end

  private

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  attr_reader :name

  # @return [Siege::System::Loader, NilClass]
  #
  # @api private
  # @sinc 0.1.0
  attr_reader :loader

  # @return [Proc]
  #
  # @api private
  # @since 0.1.0
  attr_reader :loader_definition

  # @param name [String, Symbol]
  # @param loader [Siege::System::Loader, NilClass]
  # @param loader_definition [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def prevent_incompatabilities!(name, loader, loader_definition)
    Siege::System::Element::NameGuard.prevent_incomparabilities!(name)

    if !loader.nil? && !loader.is_a?(Class) && !(loader <= Siege::System::Loader)
      raise(
        Siege::System::ArgumentError,
        'System Loader should be a class inherited from Siege::System::Loader'
      )
    end

    if loader.nil? && loader_definition.nil?
      raise(
        Siege::System::ArgumentError,
        'System Loader object/definition is not provided'
      )
    end

    if !loader.nil? && !loader_definition.nil?
      raise(
        Siege::System::AmbiguousElementDefinitionError,
        'You should privde a loader definitions OR a loader object (not a both)'
      )
    end
  end
end
