# frozen_string_literal: true

# @api public
# @since 0.1.0
class Siege::System
  require_relative 'system/errors'
  require_relative 'system/loader'
  require_relative 'system/element'
  require_relative 'system/builder'
  require_relative 'system/dsl'

  # @since 0.1.0
  include Siege::System::DSL

  class << self
    # @return [Siege::System]
    #
    # @api public
    # @since 0.1.0
    def build_instance
      Siege::System::Builder.build(self)
    end
  end

  # @param elements [Siege::Core::Container<Siege::System::Element>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  attr_reader :elements

  # @param elements [Siege::Core::Container<Siege::System::Element>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(elements)
    @elements = elements
  end
end
