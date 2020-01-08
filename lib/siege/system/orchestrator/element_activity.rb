# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Orchestrator::ElementActivity
  # @param system [Siege::System]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(system)
    @system = system
  end

  private

  # @return [Siege::System]
  #
  # @api private
  # @since 0.1.0
  attr_reader :system

  # @param element_names [Array<String, Symbol>]
  # @return [void]
  #
  # @raise [Siege::System::ArgumentError]
  # @raise [Siege::System::SystemElementNotFoundError]
  #
  # @api private
  # @since 0.1.0
  def prepare_element_identifiers(element_names)
    element_names.map do |element_name|
      Siege::System::Element::NameGuard.indifferently_accesable_name(element_name)
    end.tap do |element_identifiers|
      nonexistent_elements = element_identifiers.reject do |element_identifier|
        system.elements.key?(element_identifier)
      end

      raise(
        Siege::System::SystemElementNotFoundError,
        "Some chosen system elements does not exist " \
        "(nonexistent elements: #{nonexistent_elements.join(', ')})"
      ) if nonexistent_elements.any?
    end
  end
end
