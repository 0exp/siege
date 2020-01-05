# frozen_string_literal: true

# @api private
# @since 0.1.0
module Siege::System::Element::NameGuard
  class << self
    # @param name [String, Symbol]
    # @return [String]
    #
    # @api private
    # @since 0.1.0
    def indifferently_accesable_name(name)
      prevent_incomparabilities!(name)
      name.to_s.tap(&:freeze)
    end

    # @param name [String, Symbol]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def prevent_incomparabilities!(name)
      unless name.is_a?(String) || name.is_a?(Symbol)
        raise(Siege::System::ArgumentError, <<~ERROR_MESSAGE)
          System Element name should be a type of string or a symbol
        ERROR_MESSAGE
      end
    end
  end
end
