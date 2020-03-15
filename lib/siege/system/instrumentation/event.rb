# frozen_string_literal: true

# @api public
# @since 0.1.0
class Siege::System::Instrumentation::Event
  # @return [Hash]
  #
  # @api private
  # @since 0.1.0
  NO_PAYLOAD = {}

  # @return [Hash]
  #
  # @api private
  # @since 0.1.0
  NO_METADATA = {}

  # @return [String]
  #
  # @api public
  # @since 0.1.0
  attr_reader :id

  # @return [String]
  #
  # @api public
  # @since 0.1.0
  attr_reader :name

  # @return [Hash]
  #
  # @api public
  # @since 0.1.0
  attr_reader :payload

  # @return [Hash]
  #
  # @api public
  # @since 0.1.0
  attr_reader :metadata

  # @return [Time]
  #
  # @api public
  # @since 0.1.0
  attr_reader :start_time

  # @return [Time]
  #
  # @api public
  # @since 0.1.0
  attr_reader :end_time

  # @param id [String]
  # @param name [String]
  # @param payload [Hash]
  # @param metadata [Hash]
  # @param start_time [Time]
  # @param end_time [Time]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(id, name, payload, metadata, start_time, end_time)
    @id = id
    @name = name
    @payload = payload
    @metadata = metadata
    @start_time = start_time
    @end_time = end_time
  end

  # @return [Hash]
  #
  # @api public
  # @since 0.1.0
  def to_h
    {
      id: id,
      name: name,
      payload: payload,
      metadata: metadata,
      start_time: start_time,
      end_time: end_time
    }
  end
end
