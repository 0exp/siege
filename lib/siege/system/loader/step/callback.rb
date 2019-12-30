# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Loader::Step::Callback
  # @param expression [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(expression)
    @expression = expression
  end

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def call
    expression.call
  end

  private

  # @return [Proc]
  #
  # @api private
  # @since 0.1.0
  attr_reader :expression
end
