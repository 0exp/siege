# frozen_string_literal: true

# @api public
# @since 0.1.0
class Siege::System
  require_relative 'system/errors'
  require_relative 'system/loader'
  require_relative 'system/element'
  require_relative 'system/element_registry'
  require_relative 'system/factory'
  require_relative 'system/orchestrator'
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

  # @return [Siege::System::ElementRegistry]
  #
  # @api private
  # @since 0.1.0
  attr_reader :elements

  # @param elements [Siege::System::ElementRegistry]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(elements)
    @elements = elements
    @orchestrator = Siege::System::Orchestrator.new(self)
  end

  # @param element_names [Array<String, Symbol>]
  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def init!(*element_names)
    orchestrator.initialize_elements(element_names)
  end

  private

  # @param elements [Siege::System::Orchestrator]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  attr_reader :orchestrator
end
