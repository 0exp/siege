# frozen_string_literal: true

# @api public
# @since 0.1.0
class Siege::System
  require_relative 'system/errors'
  require_relative 'system/loader'
  require_relative 'system/element'
  require_relative 'system/element_registry'
  require_relative 'system/factory'
  require_relative 'system/dsl'

  # @since 0.1.0
  include Siege::System::DSL

  class << self
    # @return [Siege::System]
    #
    # @api public
    # @since 0.1.0
    def create_instance
      Siege::System::Factory.create(self)
    end
  end

  # @param elements [Siege::System::ElementRegistry]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(elements)
    @elements = elements
  end

  private

  # @param elements [Siege::System::ElementRegistry]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  attr_reader :elements
end
