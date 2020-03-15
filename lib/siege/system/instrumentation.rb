# frozen_string_literal: true

# TODO: move to Siege::Tools

# @api private
# @since 0.1.0
class Siege::System::Instrumentation
  require_relative 'instrumentation/errors'
  require_relative 'instrumentation/event'
  require_relative 'instrumentation/queue'
  require_relative 'instrumentation/subscriber'
  require_relative 'instrumentation/notifier'

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
  end

  # @param event [String]
  # @param listener [Block]
  # @return [Siege::System::Instrumentation::Subscriber]
  #
  # @api private
  # @since 0.1.0
  def subscribe(event, &listener)
  end

  # @param event [String]
  # @param logic [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def instrument(event, &logic)
  end
end

__END__

system_entity.subscribe('database.init') do |event|
end # => subscriber

system_entity.subscribe('*.init') do |event|
end # => subscriber

