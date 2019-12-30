# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Loader::DSL::Commands::Abstract
  # @return [NilClass, Proc]
  #
  # @api private
  # @since 0.1.0
  attr_reader :expression

  # @param expression [NilClass, Proc]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(expression = nil)
    @expression = expression
  end

  # @return [Siege::System::Loader::DSL::Commands::Abstract]
  #
  # @api private
  # @since 0.1.0
  def dup
    self.class.new(expression)
  end
end
