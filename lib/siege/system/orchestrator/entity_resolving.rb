# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Orchestrator::EntityResolving
  # @param system [Siege:System]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(system)
    @system = system
  end

  # @return [Hash<String,Any>]
  #
  # @api private
  # @since 0.1.0
  def entities
    system.elements.each_with_object({}) do |(element_name, element), system_entity_list|
      element.each_entity do |entity_name, entity|
        system_entity_name =
          "#{element_name}" \
          "#{Siege::System::Element::NameGuard::ELEMENT_ENTITY_PATH_PART_SEPARATOR}" \
          "#{entity_name}"

        system_entity_list[system_entity_name] = entity
      end
    end
  end

  # @param element_entity_path [String]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def resolve(element_entity_path)
    prepare_path_parts(element_entity_path) in { element: element_path, entity: entity_path }
    resolve_element_entity(resolve_element(element_path), entity_path)
  end

  private

  # @return [Siege::System]
  #
  # @api private
  # @since 0.1.0
  attr_reader :system

  # @param element_entity_path [String]
  # @return [Array<String>]
  #
  # @api private
  # @since 0.1.0
  def prepare_path_parts(element_entity_path)
    Siege::System::Element::NameGuard.path_parts_for(element_entity_path).tap do |parts|
      raise(
        Siege::System::ArgumentError,
        'System element is not provided (you should provide both system element and element entity)'
      ) if parts[:element].empty?

      raise(
        Siege::System::ArgumentError,
        'Element entity is not provided (you should provide both system element and element entity)'
      ) if parts[:entity].empty?
    end
  end

  # @return [Siege::System::Element]
  #
  # @api private
  # @since 0.1.0
  def resolve_element(element_path)
    system.elements[element_path]
  rescue SmartCore::Container::ResolvingError
    raise(Siege::System::SystemElementNotFoundError.new(missing_elements: [element_path]))
  end

  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def resolve_element_entity(element, entity_path)
    element[entity_path]
  rescue SmartCore::Container::ResolvingError
    raise(Siege::System::SystemElementEntityNotFoundError.new(missing_entities: [entity_path]))
  end
end
