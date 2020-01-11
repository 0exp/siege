# frozen_string_literal: true

class Siege::System::Factory::Configurations
  # @api private
  # @since 0.1.0
  class ElementCommand < AbstractCommand
    # @return [Hash<String|Symbol,Any>]
    #
    # @api private
    # @since 0.1.0
    attr_reader :settings_map

    # @param settings_map [Hash<String|Symbol,Any>]
    # @param expression [Proc]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def initialize(settings_map, expression)
      @settings_map = settings_map
      super(expression)
    end
  end
end
