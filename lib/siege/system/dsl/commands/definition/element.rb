# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::DSL::Commands::Element < Siege::System::DSL::Commands::Abstract
  # @param name [String, Symbol]
  # @param loader_definition [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(name, loader_definition)
    raise(
      Siege::System::ArgumentError,
      'System Loader definition should be a type of Proc'
    ) unless loader_definition.is_a?(Proc)

    @name = Siege::System::Element::NameGuard.indifferently_accesable_name(name)
    @loader_definition = loader_definition
  end

  private

  # @return [String]
  #
  # @api private
  # @since 0.1.0
  attr_reader :name

  # @return [Proc]
  #
  # @api private
  # @since 0.1.0
  attr_reader :loader_definition
end
