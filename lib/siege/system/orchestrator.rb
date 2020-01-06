# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Orchestrator
  # @rparam elements [Siege::System::ElementRegistry]
  #
  # @api private
  # @since 0.1.0
  def initialize(system)
    @elements = elements
  end

  # @param element_names [Array<String, Symbol>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initializee_elements(element_names)
    Siege::System::Element::NameGuard.prevent_incomparabilities!(*element_names)
  end
end
