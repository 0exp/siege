# frozen_string_literal: true

# @api public
# @since 0.1.0
class Siege::System::Loader
  require_relative 'loader/dsl'
  require_relative 'loader/step'
  require_relative 'loader/factory'
  require_relative 'loader/status'
  require_relative 'loader/invocation_context'

  # @since 0.1.0
  include Siege::System::Loader::DSL

  # @param invocation_context [Siege::System::Loader::InvocationContext]
  # @option init [Siege::System::Loader::Step::Expression]
  # @option start [Siege::System::Loader::Step::Expression]
  # @option stop [Siege::System::Loader::Step::Expression]
  # @option before_init [Siege::System::Loader::Step::Callbacks]
  # @option after_init [Siege::System::Loader::Step::Callbacks]
  # @option before_start [Siege::System::Loader::Step::Callbacks]
  # @option after_start [Siege::System::Loader::Step::Callbacks]
  # @option before_stop [Siege::System::Loader::Step::Callbacks]
  # @option after_stop [Siege::System::Loader::Step::Callbacks]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(
    invocation_context,
    init:,
    start:,
    stop:,
    before_init:,
    after_init:,
    before_start:,
    after_start:,
    before_stop:,
    after_stop:
  )
    @lock = Siege::Core::Lock.new
    @status = Siege::System::Loader::Status.new

    @invocation_context = invocation_context

    @init  = init
    @start = start
    @stop  = stop

    @before_init  = before_init
    @after_init   = after_init
    @before_start = before_start
    @after_start  = after_start
    @before_stop  = before_stop
    @after_stop   = after_stop
  end

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  def status_identifier
    status.identifier
  end

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def init!
    thread_safe do
      next if status.initialized?
      before_init.call # TODO: run_in_context too
      status.transit_to_init { run_in_context(init) }
      after_init.call # TODO: run_in_context too
    end
  end

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def start!
    thread_safe do
      next if status.started?
      before_start.call # TODO: run_in_context too
      status.transit_to_start { run_in_context(start) }
      after_start.call # TODO: run_in_context too
    end
  end

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def stop!
    thread_safe do
      next if status.stopped?
      before_stop.call # TODO: run_in_context too
      status.transit_to_stop { run_in_context(stop) }
      after_stop.call # TODO: run_in_context too
    end
  end

  private

  # @return [Siege::System::Loader::InvocationContext]
  #
  # @api private
  # @since 0.1.0
  attr_reader :invocation_context

  # @return [Siege::System::Loader::Status]
  #
  # @api private
  # @since 0.1.0
  attr_reader :status

  # @return [Siege::System::Loader::Step::Expression]
  #
  # @api private
  # @since 0.1.0
  attr_reader :init

  # @return [Siege::System::Loader::Step::Expression]
  #
  # @api private
  # @since 0.1.0
  attr_reader :start

  # @return [Siege::System::Loader::Step::Expression]
  #
  # @api private
  # @since 0.1.0
  attr_reader :stop

  # @return [Siege::System::Loader::Step::Callbacks]
  #
  # @api private
  # @since 0.1.0
  attr_reader :before_init

  # @return [Siege::System::Loader::Step::Callbacks]
  #
  # @api private
  # @since 0.1.0
  attr_reader :after_init

  # @return [Siege::System::Loader::Step::Callbacks]
  #
  # @api private
  # @since 0.1.0
  attr_reader :before_start

  # @return [Siege::System::Loader::Step::Callbacks]
  #
  # @api private
  # @since 0.1.0
  attr_reader :after_start

  # @return [Siege::System::Loader::Step::Callbacks]
  #
  # @api private
  # @since 0.1.0
  attr_reader :before_stop

  # @return [Siege::System::Loader::Step::Callbacks]
  #
  # @api private
  # @since 0.1.0
  attr_reader :after_stop

  # @param expression [Siege::System::Loader::Step::Expression]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def run_in_context(expression)
    invocation_context.____instance_eval____(&expression)
  end

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
