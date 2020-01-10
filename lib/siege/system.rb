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
    def build
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

  # @param element_entity_path [String]
  # @return [Any]
  #
  # @api public
  # @since 0.1.0
  def resolve(element_entity_path)
    orchestrator.resolve_element_entity(element_entity_path)
  end
  alias_method :[], :resolve

  # @return [Hash<String,Any>]
  #
  # @api public
  # @sinc 0.1.0
  def entities
    orchestrator.resolve_system_entities
  end

  # @return [Hash<String,Symbol>]
  #
  # @api public
  # @since 0.1.0
  def status
    orchestrator.element_statuses
  end

  # @param element_names [Array<String, Symbol>]
  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def init(*element_names)
    orchestrator.initialize_elements(element_names)
  end

  # @param element_names [Array<String, Symbol>]
  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def start(*element_names)
    orchestrator.start_elements(element_names)
  end

  # @param element_names [Array<String, Symbol>]
  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def stop(*element_names)
    orchestrator.stop_elements(element_names)
  end

  # @param element_names [Array<String, Symbol>]
  # @return [void]
  #
  # @api public
  # @since 0.1.0
  def reload(*element_names)
    orchestrator.reload_elements(element_names)
  end

  private

  # @return [Siege::System::Orchestrator]
  #
  # @api private
  # @since 0.1.0
  attr_reader :orchestrator
end
