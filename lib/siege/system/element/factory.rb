# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Element::Factory
  class << self
    # @param element_name [String, Symbol]
    # @param loader_klass [Class<Siege::System::Loader>, NilClass]
    # @param loader_definition [Proc, NilClass]
    # @return [Siege::System::Element]
    #
    # @api private
    # @since 0.1.0
    def create(element_name, loader_klass, loader_definition)
      new(element_name, loader_klass, loader_definition).create
    end
  end

  # @param element_name [String, Symbol]
  # @param loader_klass [Class<Siege::System::Loader>, NilClass]
  # @param loader_definition [Proc, NilClass]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(element_name, loader_klass, loader_definition)
    @element_name = element_name
    @loader_klass = loader_klass
    @loader_definition = loader_definition
  end

  # @return [Siege::System::Element]
  #
  # @api private
  # @since 0.1.0
  def create
    create_element(create_loader)
  end

  private

  # @return [String, Symbol]
  #
  # @api private
  # @since 0.1.0
  attr_reader :element_name

  # @return [Class<Siege::System::Loader>, NilClass]
  #
  # @api private
  attr_reader :loader_klass

  # @return [Proc, NilClass]
  #
  # @api private
  # @since 0.1.0
  attr_reader :loader_definition

  # @return [Siege::System::Loader]
  #
  # @api private
  # @since 0.1.0
  def create_loader
    case
    when loader_klass
      Siege::System::Loader::Factory.create(loader_klass)
    when loader_definition
      Siege::System::Loader::Factory.create_from_definitions(loader_definition)
    end
  end

  # @param loader [Siege::System::Loader]
  # @return [Siege::System::Element]
  #
  # @pai private
  # @since 0.1.0
  def create_element(loader)
    Siege::System::Element.new(element_name, loader)
  end
end
