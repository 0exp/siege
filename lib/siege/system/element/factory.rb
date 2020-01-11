# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Element::Factory
  class << self
    # @param element_name [String, Symbol]
    # @param loader_klass [Class<Siege::System::Loader>, NilClass]
    # @param loader_definition [Proc, NilClass]
    # @param system_instance [Siege::System]
    # @return [Siege::System::Element]
    #
    # @api private
    # @since 0.1.0
    def create(element_name, loader_klass, loader_definition, system_instance)
      new(element_name, loader_klass, loader_definition, system_instance).create
    end
  end

  # @param element_name [String, Symbol]
  # @param loader_klass [Class<Siege::System::Loader>, NilClass]
  # @param loader_definition [Proc, NilClass]
  # @param system_instance [Siege::System]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(element_name, loader_klass, loader_definition, system_instance)
    @element_name      = element_name
    @loader_klass      = loader_klass
    @loader_definition = loader_definition
    @system_instance   = system_instance
  end

  # @return [Siege::System::Element]
  #
  # @api private
  # @since 0.1.0
  def create
    element_allocation = allocate_element
    invocation_context = allocate_invocation_context
    loader_instance = create_loader(invocation_context)
    initialize_invocation_context(invocation_context, element_allocation, loader_instance)
    initialize_element_instance(element_allocation, loader_instance)
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

  # @return [Siege::System]
  #
  # @api private
  # @since 0.1.0
  attr_reader :system_instance

  # @return allocation [Siege::System::Element]
  #
  # @api private
  # @since 0.1.0
  def allocate_element
    Siege::System::Element.allocate
  end

  # @param element_allocation [Siege::System::Element]
  # @return [Siege::System::Loader::InvocationContext]
  #
  # @api private
  # @since 0.1.0
  def allocate_invocation_context
    Siege::System::Loader::InvocationContext.allocate
  end

  # @param invocation_context [Siege::System::Loader::InvocationContext]
  # @return [Siege::System::Loader]
  #
  # @api private
  # @since 0.1.0
  def create_loader(invocation_context)
    case
    when loader_klass
      Siege::System::Loader::Factory.create(loader_klass, invocation_context)
    when loader_definition
      Siege::System::Loader::Factory.create_from_definitions(loader_definition, invocation_context)
    end
  end

  # @param context [Siege::System::Loader::InvocationContext]
  # @param system [Siege::System]
  # @param element_allocation [Siege::System::Element]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize_invocation_context(context, element_allocation, loader)
    context.send(:initialize, system_instance, element_allocation, loader)
  end

  # @param element_allocation [Siege::System::Element]
  # @param loader [Siege::System::Loader]
  # @return [void]
  #
  # @pai private
  # @since 0.1.0
  def initialize_element_instance(element_allocation, loader)
    element_allocation.send(:initialize, element_name, loader)
    element_allocation
  end
end
