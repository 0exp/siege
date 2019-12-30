# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Loader::DSL::CommandSet
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

  # @param command [Siege::System::Loader::DSL::Command::Abstract]
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

  # @return [Siege::System::Loader::DSL::CommandSet]
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

  private

  # @return [Array<Siege::System::Loader::DSL::Command::Abstract>]
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
