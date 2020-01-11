# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Orchestrator::Stopper < Siege::System::Orchestrator::ElementActivity
  # @param element_names [Array<String, Symbol>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def stop(element_names)
    element_identifiers = prepare_element_identifiers(element_names)
    element_identifiers.empty? ? stop_all_elements : stop_elements(element_identifiers)
  end

  private

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def stop_all_elements
    system.elements.each { |_element_name, element| element.stop! }
  end

  # @param element_names [Array<String, Symbol>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def stop_elements(element_names)
    element_names.each do |element_name|
      system.elements[element_name].stop!
    end
  end
end
