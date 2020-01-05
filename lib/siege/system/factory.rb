# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Factory
  class << self
    # @param system_klass [Class<Siege::System>]
    # @return [Siege::System]
    #
    # @api private
    # @since 0.1.0
    def create(system_klass)
      new(system_klass).create
    end
  end

  # @param system_klass [Class<Siege::System>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(system_klass)
    @system_klass = system_klass
  end

  # @return [Siege::System]
  #
  # @api private
  # @since 0.1.0
  def create
    system_elements = build_system_elements
    system_instance = build_system_instance(system_elements)

    build_definitions(system_instance, system_elements)
    build_state(system_instance, system_elements)

    system_instance
  end

  private

  # @return [Class<Siege::System>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :system_klass

  # @return [Siege::System::ElementRegistry]
  #
  # @api private
  # @sinec 0.1.0
  def build_system_elements
    Siege::System::ElementRegistry.new
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
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def build_definitions(system_instance, system_elements)
    system_klass.definition_commands.each do |command|
      command.call(system_instance, system_elements)
    end
  end

  # @param system_instance [Siege::System]
  # @param system_elements [Siege::System::ElementRegistry]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def build_state(system_instance, system_elements)
    system_klass.instantiation_commands.each do |command|
      command.call(system_instance, system_elements)
    end
  end
end
