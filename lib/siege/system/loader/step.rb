# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Loader::Step
  require_relative 'step/builder'
  require_relative 'step/callback'
  require_relative 'step/callbacks'

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

  private

  # @return [Proc, NilClass]
  #
  # @api private
  # @since 0.1.0
  attr_reader :process
end
