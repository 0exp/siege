# frozen_string_literal: true

# @api public
# @since 0.1.0
class Siege::System::Loader
  require_relative 'loader/dsl'
  require_relative 'loader/step'
  require_relative 'loader/builder'
  require_relative 'loader/status'

  # @since 0.1.0
  include Siege::System::Loader::DSL

  class << self
    # @return [Siege::System::Loader]
    #
    # @api public
    # @since 0.1.0
    def build
      Siege::System::Loader::Builder.build(self)
    end
  end

  # @option init [Siege::System::Loader::Step]
  # @option start [Siege::System::Loader::Step]
  # @option stop [Siege::System::Loader::Step]
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
    @lock   = Siege::Core::Lock.new
    @status = Siege::System::Loader::Status.new

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

  private

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

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
