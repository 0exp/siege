# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Factory::Configurations
  require_relative 'configurations/abstract_command'
  require_relative 'configurations/element_command'
  require_relative 'configurations/element_command_set'

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @__element_configurations__ = Siege::System::Factory::Configurations::ElementCommandSet.new
  end

  # @param element_identifier [String, Symbol]
  # @param settings_map [Hash<String|Symbol,Any>]
  # @param configuration [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def configure(element_identifier, settings_map = {}, &configuration)
    __element_configurations__.add(element_identifier, settings_map, configuration)
  end

  # @param element_name [String]
  # @param block [Block]
  # @yield [command]
  # @yieldparam command [Siege::System::Factory::Configurations::ElementCommand]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def each_element_config(element_name, &block)
    __element_configurations__.each_for(element_name, &block)
  end

  private

  # @return [Siege::System::Factory::Configurations::ElementCommandSet]
  #
  # @api private
  # @since 0.1.0
  attr_reader :__element_configurations__
end
