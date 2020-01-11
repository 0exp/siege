# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Orchestrator::Reloader < Siege::System::Orchestrator::ElementActivity
  # @param element_names [Array<String, Symbol>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def reload(*element_names)
    element_identifiers = prepare_element_identifiers(element_names)
    element_identifiers.empty? ? reload_all_elements : reload_elements(element_identifiers)
  end

  private

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def reload_all_elements
    system.elements.each { |_element_name, element| element.reload! }
  end

  # @param element_names [Array<String, Symbol>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def reload_elements(element_names)
    element_names.each do |element_name|
      system.elements[element_name].reload!
    end
  end
end
