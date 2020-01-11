# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Factory::Configurations::ElementCommandSet
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @lock = Siege::Core::Lock.new
    @configurations = Hash.new { |hash, key| hash[key] = [] }
  end

  # @param element_identifier [String, Symbol]
  # @param settings_map [Hash<String|Symbol,Any>]
  # @param configuration [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def add(element_identifier, settings_map, configuration)
    thread_safe do
      identifier = indifferent_identifier(element_identifier)
      command = create_configuration_command(settings_map, configuration)
      configurations[identifier] << command
    end
  end

  # @param element_identifier [String]
  # @param block [Block]
  # @yield [command]
  # @yieldparam command [Siege::System::Factory::Configurations::ElementCommand]
  # @return [Enumerable]
  #
  # @api private
  # @since 0.1.0
  def each_for(element_identifier, &block)
    thread_safe do
      if block_given?
        configurations[element_identifier].each(&block)
      else
        configurations[element_identifier].each
      end
    end
  end

  private

  # @return [Hash<String,Array<Siege::System::Factory::Configurations::ElementCommand>>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :configurations

  # @param element_identifier [String, Symbol]
  # @return [String]
  #
  # @api private
  # @since 0.1.0
  def indifferent_identifier(element_identifier)
    Siege::System::Element::NameGuard.indifferently_accesable_name(element_identifier)
  end

  # @param configuration [Proc]
  # @param settings_map [Hash<String|Symbol,Any>]
  # @return [Siege::System::Factory::Configurations::ElementCommand]
  #
  # @api private
  # @since 0.1.0
  def create_configuration_command(settings_map, configuration)
    Siege::System::Factory::Configurations::ElementCommand.new(settings_map, configuration)
  end

  # @param block [Block]
  # @return [Any]
  #
  # @api private
  # @since 0.1.0
  def thread_safe(&block)
    @lock.synchronize(&block)
  end
end
