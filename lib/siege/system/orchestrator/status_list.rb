# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Orchestrator::StatusList
  # @param system [Siege::System]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(system)
    @system = system
  end

  # @return [Hash<String,Symbol]
  #
  # @api private
  # @since 0.1.0
  def calculate
    system.elements.each_with_object({}) do |(element_name, element), list|
      list[element_name] = element.status
    end
  end

  private

  # @return [Siege::System]
  #
  # @api private
  # @since 0.1.0
  attr_reader :system
end
