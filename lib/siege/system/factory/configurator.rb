# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Factory::Configurator
  class << self
    # @param configurations [Proc, NilClass]
    # @return [Siege::System::Factory::Configurator]
    #
    # @api private
    # @since 0.1.0
    def create(configurations)
      new(Siege::System::Factory::Configurations.new.tap do |configs|
        configurations.call(configs) if configurations
      end)
    end
  end

  # @param configurations [Siege::System::Factory::Configurations]
  #
  # @api private
  # @since 0.1.0
  def initialize(configurations)
    @configurations = configurations
  end

  # @param element_name [String]
  # @param loader [Siege::System::Loader]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def configure_element_loader(element_name, loader)
    configurations.each_element_config(element_name) do |command|
      loader.configure(&command)
    end
  end

  private

  # @return [Siege::System::Factory::Configurations]
  #
  # @api private
  # @since 0.1.0
  attr_reader :configurations
end
