# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Loader::Factory # rubocop:disable Metrics/ClassLength
  class << self
    # @param loader_klass [Class<Siege::System::Loader>]
    # @param invocation_context [Siege::System::Loader::InvocationContext]
    # @return [Siege::System::Loader]
    #
    # @api private
    # @since 0.1.0
    def create(loader_klass, invocation_context)
      new(loader_klass, invocation_context).create
    end

    # @param definitions [Proc]
    # @param invocation_context [Siege::System::Loader::InvocationContext]
    # @return [Siege::System::Loader]
    #
    # @api private
    # @since 0.1.0
    def create_from_definitions(definitions, invocation_context)
      create(create_loader_klass(definitions), invocation_context)
    end

    private

    # @param definitions [Proc]
    # @return [Class<Siege::System::Loader>]
    #
    # @api private
    # @since 0.1.0
    def create_loader_klass(definitions)
      Class.new(Siege::System::Loader, &definitions)
    end
  end

  # @param loader_klass [Class<Siege::System::Loader>]
  # @param invocation_context [Siege::System::Loader::InvocationContext]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(loader_klass, invocation_context)
    @loader_klass = loader_klass
    @invocation_context = invocation_context

    @init  = nil
    @start = nil
    @stop  = nil

    @before_init  = Siege::System::Loader::Step::Callbacks.new
    @after_init   = Siege::System::Loader::Step::Callbacks.new
    @before_start = Siege::System::Loader::Step::Callbacks.new
    @after_start  = Siege::System::Loader::Step::Callbacks.new
    @before_stop  = Siege::System::Loader::Step::Callbacks.new
    @after_stop   = Siege::System::Loader::Step::Callbacks.new
  end

  # @return [Siege::System::Loader]
  #
  # @api private
  # @since 0.1.0
  def create # rubocop:disable Metrics/AbcSize
    on_init(loader_klass.on_init)
    on_start(loader_klass.on_start)
    on_stop(loader_klass.on_stop)
    on_before_init(loader_klass.on_before_init)
    on_after_init(loader_klass.on_after_init)
    on_before_start(loader_klass.on_before_start)
    on_after_start(loader_klass.on_after_start)
    on_before_stop(loader_klass.on_before_stop)
    on_after_stop(loader_klass.on_after_stop)

    create_instance!
  end

  private

  # @return [Class<Siege::System::Loader>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :loader_klass

  # @return [Siege::System::Loader::InvocationContext]
  #
  # @api private
  # @since 0.1.0
  attr_reader :invocation_context

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

  # @return [Siege::System::Loader]
  #
  # @api private
  # @since 0.1.0
  def create_instance!
    loader_klass.new(
      invocation_context,
      init: init,
      stop: stop,
      start: start,
      before_init: before_init,
      after_init: after_init,
      before_start: before_start,
      after_start: after_start,
      before_stop: before_stop,
      after_stop: after_stop
    )
  end

  # @param command [Siege::System::Loader::DSL::Commands::Init]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def on_init(command)
    @init = Siege::System::Loader::Step::Expression.new(command.expression)
  end

  # @param command [Siege::System::Loader::DSL::Commands::Start]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def on_start(command)
    @start = Siege::System::Loader::Step::Expression.new(command.expression)
  end

  # @param command [Siege::System::Loader::DSL::Commands::Stop]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def on_stop(command)
    @stop = Siege::System::Loader::Step::Expression.new(command.expression)
  end

  # @param commands [Siege::System::Loader::DSL::CommandSet]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def on_before_init(commands)
    commands.each do |command|
      before_init.add(Siege::System::Loader::Step::Callback.new(command.expression))
    end
  end

  # @param commands [Siege::System::Loader::DSL::CommandSet]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def on_after_init(commands)
    commands.each do |command|
      after_init.add(Siege::System::Loader::Step::Callback.new(command.expression))
    end
  end

  # @param commands [Siege::System::Loader::DSL::CommandSet]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def on_before_start(commands)
    commands.each do |command|
      before_start.add(Siege::System::Loader::Step::Callback.new(command.expression))
    end
  end

  # @param commands [Siege::System::Loader::DSL::CommandSet]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def on_after_start(commands)
    commands.each do |command|
      after_start.add(Siege::System::Loader::Step::Callback.new(command.expression))
    end
  end

  # @param commands [Siege::System::Loader::DSL::CommandSet]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def on_before_stop(commands)
    commands.each do |command|
      before_stop.add(Siege::System::Loader::Step::Callback.new(command.expression))
    end
  end

  # @param commands [Siege::System::Loader::DSL::CommandSet]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def on_after_stop(commands)
    commands.each do |command|
      after_stop.add(Siege::System::Loader::Step::Callback.new(command.expression))
    end
  end
end
