# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Factory
  require_relative 'factory/configurations'
  require_relative 'factory/configurator'

  class << self
    # @param system_klass [Class<Siege::System>]
    # @param configurations [Proc, NilClass]
    # @return [Siege::System]
    #
    # @api private
    # @since 0.1.0
    def create(system_klass, configurations)
      new(system_klass, configurations).create
    end
  end

  # @param system_klass [Class<Siege::System>]
  # @param configurations [Proc, NilClass]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(system_klass, configurations)
    @system_klass = system_klass
    @configurations = configurations
  end

  # @return [Siege::System]
  #
  # @api private
  # @since 0.1.0
  def create
    system_configurator = build_system_configurator
    system_elements = build_system_elements
    system_instance = build_system_instance(system_elements)

    build_definitions(system_instance, system_elements, system_configurator)
    build_state(system_instance, system_elements, system_configurator)

    system_instance
  end

  private

  # @return [Class<Siege::System>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :system_klass

  # @return [Proc, NilClass]
  #
  # @api private
  # @since 0.1.0
  attr_reader :configurations

  # @return [Siege::System::ElementRegistry]
  #
  # @api private
  # @sinec 0.1.0
  def build_system_elements
    Siege::System::ElementRegistry.new
  end

  # @return [Siege::System::Factory::Configurator]
  #
  # @api private
  # @since 0.1.0
  def build_system_configurator
    Siege::System::Factory::Configurator.create(configurations)
  end

  # @param system_elements [Siege::System::ElementRegistry]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def build_system_instance(system_elements)
    system_klass.new(system_elements)
  end

  # @param system_instance [Siege::System]
  # @param system_elements [Siege::System::ElementRegistry]
  # @param system_configurator [Siege::System::Factory::Configurator]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def build_definitions(system_instance, system_elements, system_configurator)
    system_klass.definition_commands.each do |command|
      command.call(system_instance, system_elements, system_configurator)
    end
  end

  # @param system_instance [Siege::System]
  # @param system_elements [Siege::System::ElementRegistry]
  # @param system_configurator [Siege::System::Factory::Configurator]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def build_state(system_instance, system_elements, system_configurator)
    system_klass.instantiation_commands.each do |command|
      command.call(system_instance, system_elements, system_configurator)
    end
  end
end
