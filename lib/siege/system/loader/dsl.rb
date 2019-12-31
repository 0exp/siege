# frozen_string_literal: true

# @api private
# @since 0.1.0
module Siege::System::Loader::DSL
  require_relative 'dsl/commands'
  require_relative 'dsl/command_set'

  class << self
    # @param child_klass [Class<Siege::System::Loader>]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def included(child_klass) # rubocop:disable Metrics/AbcSize
      child_klass.instance_variable_set(:@definition_lock, Siege::Core::Lock.new)

      child_klass.instance_variable_set(:@on_init,  Commands::Init.new)
      child_klass.instance_variable_set(:@on_start, Commands::Start.new)
      child_klass.instance_variable_set(:@on_stop,  Commands::Stop.new)

      child_klass.instance_variable_set(:@on_before_init,  CommandSet.new)
      child_klass.instance_variable_set(:@on_after_init,   CommandSet.new)
      child_klass.instance_variable_set(:@on_before_start, CommandSet.new)
      child_klass.instance_variable_set(:@on_after_start,  CommandSet.new)
      child_klass.instance_variable_set(:@on_before_stop,  CommandSet.new)
      child_klass.instance_variable_set(:@on_after_stop,   CommandSet.new)

      child_klass.extend(ClassMethods)

      child_klass.singleton_class.prepend(Module.new do
        def inherited(child_klass) # rubocop:disable Metrics/AbcSize
          child_klass.instance_variable_set(:@definition_lock, Siege::Core::Lock.new)

          child_klass.instance_variable_set(:@on_init,  on_init.dup)
          child_klass.instance_variable_set(:@on_start, on_start.dup)
          child_klass.instance_variable_set(:@on_stop,  on_stop.dup)

          child_klass.instance_variable_set(:@on_before_init,  on_before_init.dup)
          child_klass.instance_variable_set(:@on_after_init,   on_after_init.dup)
          child_klass.instance_variable_set(:@on_before_start, on_before_start.dup)
          child_klass.instance_variable_set(:@on_after_start,  on_after_start.dup)
          child_klass.instance_variable_set(:@on_before_stop,  on_before_stop.dup)
          child_klass.instance_variable_set(:@on_after_stop,   on_after_stop.dup)
        end
      end)
    end
  end

  # @api private
  # @since 0.1.0
  module ClassMethods
    # @return [Siege::System::Loader::DSL::Commands::Init]
    #
    # @api private
    # @since 0.1.0
    attr_reader :on_init

    # @return [Siege::System::Loader::DSL::Commands::Start]
    #
    # @api private
    # @since 0.1.0
    attr_reader :on_start

    # @return [Siege::System::Loader::DSL::Commands::Stop]
    #
    # @api private
    # @since 0.1.0
    attr_reader :on_stop

    # @return [Siege::System::Loader::DSL::CommandSet]
    #
    # @api private
    # @since 0.1.0
    attr_reader :on_before_init

    # @return [Siege::System::Loader::DSL::CommandSet]
    #
    # @api private
    # @since 0.1.0
    attr_reader :on_after_init

    # @return [Siege::System::Loader::DSL::CommandSet]
    #
    # @api private
    # @since 0.1.0
    attr_reader :on_before_start

    # @return [Siege::System::Loader::DSL::CommandSet]
    #
    # @api private
    # @since 0.1.0
    attr_reader :on_after_start

    # @return [Siege::System::Loader::DSL::CommandsSet]
    #
    # @api private
    # @since 0.1.0
    attr_reader :on_before_stop

    # @return [Siege::System::Loader::DSL::CommandsSet]
    #
    # @api private
    # @since 0.1.0
    attr_reader :on_after_stop

    # @param expression [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def init(&expression)
      @on_init = Commands::Init.new(expression)
    end

    # @param expression [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def start(&expression)
      @on_start = Commands::Start.new(expression)
    end

    # @param expression [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def stop(&expression)
      @on_stop = Commands::Stop.new(expression)
    end

    # @param process_type [String, Symbol]
    # @param expression [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def before(process_type, &expression)
      case process_type
      when :init  then before_init(&expression)
      when :start then before_start(&expression)
      when :stop  then before_stop(&expression)
      else
        raise(Siege::System::ArgumentError, "Incompatible before-callback type #{process_type}")
      end
    end

    # @param process_type [String, Symbol]
    # @param expression [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def after(process_type, &expression)
      case process_type
      when :init  then after_init(&expression)
      when :start then after_start(&expression)
      when :stop  then after_stop(&expression)
      else
        raise(Siege::System::ArgumentError, "Incompatible after-callback type #{process_type}")
      end
    end

    # @param expression [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def before_init(&expression)
      on_before_init << Commands::BeforeInit.new(expression)
    end

    # @param expression [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def after_init(&expression)
      on_after_init << Commands::AfterInit.new(expression)
    end

    # @param expression [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def before_start(&expression)
      on_before_start << Commands::BeforeStart.new(expression)
    end

    # @param expression [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def after_start(&expression)
      on_after_start << Commands::AfterStart.new(expression)
    end

    # @param expression [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def before_stop(&expression)
      on_before_stop << Commands::BeforeStop.new(expression)
    end

    # @param expression [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def after_stop(&expression)
      on_after_stop << Commands::AfterStop.new(expression)
    end
  end
end
