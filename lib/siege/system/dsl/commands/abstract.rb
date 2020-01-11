# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::DSL::Commands::Abstract
  class << self
    # @param identifier [Boolean]
    # @return [Boolean]
    #
    # @api private
    # @since 0.19.0
    def inheritable=(identifier)
      @inheritable = identifier
    end

    # @return [Boolean]
    #
    # @api private
    # @since 0.19.0
    def inheritable?
      @inheritable
    end

    # @param child_klass [Class]
    # @return [Boolean]
    #
    # @api private
    # @since 0.19.0
    def inherited(child_klass)
      child_klass.instance_variable_set(:@inheritable, true)
      super
    end
  end

  # @param system_instance [Siege::System]
  # @param system_elements [Siege::System::ElementRegistry]
  # @param system_configurator [Siege::System::Configurator]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def call(system_instance, system_elements, system_configurator); end

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def inheritable?
    self.class.inheritable?
  end
end
