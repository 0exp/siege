# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Orchestrator
  require_relative 'orchestrator/element_activity'
  require_relative 'orchestrator/initializer'
  require_relative 'orchestrator/starter'
  require_relative 'orchestrator/stopper'
  require_relative 'orchestrator/reloader'
  require_relative 'orchestrator/status_list'
  require_relative 'orchestrator/entity_resolving'

  # @param system [Siege::System]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(system)
    @lock             = Siege::Core::Lock.new
    @initializer      = Siege::System::Orchestrator::Initializer.new(system)
    @starter          = Siege::System::Orchestrator::Starter.new(system)
    @stopper          = Siege::System::Orchestrator::Stopper.new(system)
    @reloader         = Siege::System::Orchestrator::Reloader.new(system)
    @status_list      = Siege::System::Orchestrator::StatusList.new(system)
    @entity_resolving = Siege::System::Orchestrator::EntityResolving.new(system)
  end

  # @param element_entity_path [String]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def resolve_element_entity(element_entity_path)
    thread_safe { entity_resolving.resolve(element_entity_path) }
  end

  # @return [Hash<String,Any>]
  #
  # @api private
  # @since 0.1.0
  def resolve_system_entities
    thread_safe { entity_resolving.entities }
  end

  # @return [Hash<String,Symbol>]
  #
  # @api private
  # @since 0.1.0
  def element_statuses
    thread_safe { status_list.calculate }
  end

  # @param element_names [Array<String, Symbol>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize_elements(element_names)
    thread_safe { initializer.init(element_names) }
  end

  # @param element_names [Array<String, Symbol>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def start_elements(element_names)
    thread_safe { starter.start(element_names) }
  end

  # @param element_names [Array<String, Symbol>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def stop_elements(element_names)
    thread_safe { stopper.stop(element_names) }
  end

  def reload_elements(element_names)
    thread_safe { reloader.reload(element_names) }
  end

  private

  # @return [Siege::System::Orchestrator::Initializer]
  #
  # @api private
  # @since 0.1.0
  attr_reader :initializer

  # @return [Siege::System::Orchestrator::Starter]
  #
  # @api private
  # @since 0.1.0
  attr_reader :starter

  # @return [Siege::System::Orchestrator::Stopper]
  #
  # @api private
  # @since 0.1.0
  attr_reader :stopper

  # @return [Siege::System::Orchestrator::Reloader]
  #
  # @api private
  # @since 0.1.0
  attr_reader :reloader

  # @return [Siege::System::Orchestrator::StatusList]
  #
  # @api private
  # @since 0.1.0
  attr_reader :status_list

  # @return [Siege::System::Orchestrator::EntityResolving]
  #
  # @api private
  # @since 0.1.0
  attr_reader :entity_resolving

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
