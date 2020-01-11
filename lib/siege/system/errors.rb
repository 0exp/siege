# frozen_string_literal: true

class Siege::System
  # @api public
  # @since 0.1.0
  Error = Class.new(Siege::Error)

  # @api public
  # @since 0.1.0
  ArgumentError = Class.new(Siege::ArgumentError)

  # @api public
  # @since 0.1.0
  AmbiguousElementStatusError = Class.new(Error)

  # @api public
  # @since 0.1.0
  AmbiguousElementDefinitionError = Class.new(Error)

  # @api public
  # @since 0.1.0
  class SystemElementNotFoundError < Error
    # @param message [String, NilClass]
    # @option missing_elements [Array<String>]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(message = nil, missing_elements:)
      super(
        "Some chosen system elements does not exist " \
        "(nonexistent elements: #{missing_elements.join(', ')})"
      )
    end
  end

  # @api public
  # @since 0.1.0
  class SystemElementEntityNotFoundError < Error
    # @param message [String, NilClass]
    # @option missing_entities [Array<String>]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(message = nil, missing_entities:)
      super(
        "Some chosen element entities does not exist " \
        "(nonexistent entities: #{missing_entities.join(', ')})"
      )
    end
  end
end
