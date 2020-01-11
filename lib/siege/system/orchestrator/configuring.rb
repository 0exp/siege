# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Orchestrator::Configuring
  # @param system [Siege:System]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(system)
    @system = system
  end

  # @param element_name [String, Symbol]
  # @param settings_map [Hash<String|Symbol,Any>]
  # @param configurations [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def configure(element_name, settings_map = {}, &configurations)
    identifier = prepare_element_identifier(element_name)
    system.elements[identifier].configure(settings_map, &configurations)
  end

  private

  # @return [Siege::System]
  #
  # @api private
  # @since 0.1.0
  attr_reader :system

  # @param element_name [String, Symbol]
  # @retirn [String]
  #
  # @api private
  # @since 0.1.0
  def prepare_element_identifier(element_name)
    Siege::System::Element::NameGuard.indifferently_accesable_name(element_name).tap do |identifier|
      raise(
        Siege::System::SystemElementNotFoundError.new(missing_elements: [identifier])
      ) unless system.elements.key?(identifier)
    end
  end
end
