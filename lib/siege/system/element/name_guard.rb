# frozen_string_literal: true

# @api private
# @since 0.1.0
module Siege::System::Element::NameGuard
  # @return [String]
  #
  # @api private
  # @since 0.1.0
  ELEMENT_ENTITY_PATH_PART_SEPARATOR = '.'

  class << self
    # @param name [String, Symbol]
    # @return [String]
    #
    # @api private
    # @since 0.1.0
    def indifferently_accesable_name(name)
      prevent_name_incomparabilities!(name)
      name.to_s.tap(&:freeze)
    end

    # @param element_entity_path [String]
    # @return [Hash<Symbol,String>]
    #
    # @api private
    # @since 0.1.0
    def path_parts_for(element_entity_path)
      prevent_path_incomparabilities!(element_entity_path)
      element_path, *entity_path = element_entity_path.split(ELEMENT_ENTITY_PATH_PART_SEPARATOR)
      { element: element_path, entity: entity_path.join(ELEMENT_ENTITY_PATH_PART_SEPARATOR) }
    end

    # @param names [Array<String, Symbol>]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def prevent_name_incomparabilities!(*names)
      unless (names.all? { |name| name.is_a?(String) || name.is_a?(Symbol) })
        raise(Siege::System::ArgumentError, <<~ERROR_MESSAGE)
          System element/entity name should be a type of string or symbol
        ERROR_MESSAGE
      end
    end

    # @param element_entity_path [String]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def prevent_path_incomparabilities!(element_entity_path)
      unless element_entity_path.is_a?(String)
        raise(Siege::System::ArgumentError, <<~ERROR_MESSAGE)
          System element entity path should be a type of string
        ERROR_MESSAGE
      end
    end
  end
end
