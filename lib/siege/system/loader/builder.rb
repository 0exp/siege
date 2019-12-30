# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Loader::Builder
  class << self
    # @param loader_klass [Class<Siege::System::Loader>]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def build(loader_klass)
      new(loader_klass).build
    end
  end

  # @param loader_klass [Class<Siege::System::Loader>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(loader_klass)
    @loader_klass = loader_klass

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
  def build # rubocop:disable Metrics/AbcSize
    on_init(loader_klass.on_init)
    on_start(loader_klass.on_start)
    on_stop(loader_klass.on_stop)
    on_before_init(loader_klass.on_before_init)
    on_after_init(loader_klass.on_after_init)
    on_before_start(loader_klass.on_before_start)
    on_after_start(loader_klass.on_after_start)
    on_before_stop(loader_klass.on_before_stop)
    on_after_stop(loader_klass.on_after_stop)

    build_instance!
  end

  private

  # @return [Class<Siege::System::Loader>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :loader_klass

  # @return [Siege::System::Loader::Step]
  #
  # @api private
  # @since 0.1.0
  attr_reader :init

  # @return [Siege::System::Loader::Step]
  #
  # @api private
  # @since 0.1.0
  attr_reader :start

  # @return [Siege::System::Loader::Step]
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
  def build_instance!
    loader_klass.new(
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
    @init = Siege::System::Loader::Step::Builder.build(command.expression)
  end

  # @param command [Siege::System::Loader::DSL::Commands::Start]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def on_start(command)
    @start = Siege::System::Loader::Step::Builder.build(command.expression)
  end

  # @param command [Siege::System::Loader::DSL::Commands::Stop]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def on_stop(command)
    @stop = Siege::System::Loader::Step::Builder.build(command.expression)
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
