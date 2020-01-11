# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Factory::Configurations::AbstractCommand
  # @return [Proc]
  #
  # @api private
  # @since 0.1.0
  attr_reader :expression

  # @param expression [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(expression)
    @expression = expression
  end
end
