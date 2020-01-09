# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Loader::Step::Expression
  # @param process [Proc, NilClass]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(process)
    @process = process
  end

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def call
    process&.call
  end

  # @return [Proc]
  #
  # @api private
  # @since 0.1.0
  def to_proc
    process || (proc {})
  end

  private

  # @return [Proc, NilClass]
  #
  # @api private
  # @since 0.1.0
  attr_reader :process
end
