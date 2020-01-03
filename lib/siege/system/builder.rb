# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Builder
  class << self
    def build(system_klass)
      new(system_klass).build
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
  def build
    build_system_instance(build_system_elements)
  end

  private

  # @return [Class<Siege::System>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :system_klass

  # @return [Siege::Core::Container]
  #
  # @api private
  # @since 0.1.0
  def build_system_elements
    Siege::Core::Container.new.tap do |system_elements|
      system_klass.definition_commands.each do |command|
        command.call(system_elements)
      end
    end
  end

  # @return [Siege::System]
  #
  # @api private
  # @since 0.1.0
  def build_system_instance(elements)
    system_klass.new(elements).tap do |system_instance|
      system_klass.instantiation_commands.each do |command|
        command.call(system_instance)
      end
    end
  end
end
