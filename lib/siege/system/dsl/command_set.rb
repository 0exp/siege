# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::DSL::CommandSet
  # @since 0.1.0
  include Enumerable

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @lock = Siege::Core::Lock.new
    @commands = []
  end

  # @param command [Siege::System::DSL::Command::Abstract]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add(command)
    thread_safe { commands.push(command) }
  end
  alias_method :<<, :add

  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def each(&block)
    thread_safe { block_given? ? commands.each(&block) : commands.each }
  end

  # @return [Siege::System::DSL::CommandSet]
  #
  # @api private
  # @since 0.1.0
  def dup
    thread_safe do
      self.class.new.tap do |duplicate|
        each { |command| duplicate.add(command.dup) }
      end
    end
  end

  # @param command_set [Siege::System::DSL::CommandSet]
  # @param concat_condition [Block]
  # @yield [command]
  # @yieldparam command [Siege::System::DSL::Commands::Abstract]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def concat(command_set, &concat_condition)
    thread_safe do
      if block_given?
        command_set.each do |command|
          command.dup.tap { |cmd| add(cmd) if yield(cmd) }
        end
      else
        # :nocov:
        command_set.each { |command| add(command.dup) } # NOTE: unreachable at this moment
        # :nocov:
      end
    end
  end

  private

  # @return [Array<Siege::System::DSL::Command::Abstract>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :commands

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
