# frozen_string_literal: true

# @api private
# @since 0.1.0
module Siege::System::DSL
  require_relative 'dsl/commands'
  require_relative 'dsl/command_set'
  require_relative 'dsl/inheritance'

  class << self
    # @param child_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    # rubocop:disable Layout/LineLength
    def included(child_klass)
      child_klass.instance_variable_set(:@definition_commands, Siege::System::DSL::CommandSet.new)
      child_klass.instance_variable_set(:@instantiation_commands, Siege::System::DSL::CommandSet.new)
      child_klass.extend(ClassMethods)
      child_klass.singleton_class.prepend(ClassInheritance)
    end
    # rubocop:enable Layout/LineLength
  end

  # @api private
  # @since 0.1.0
  module ClassInheritance
    # @param child_klass [Class<Siege::System>]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    # rubocop:disable Layout/LineLength
    def inherited(child_klass)
      child_klass.instance_variable_set(:@definition_commands, Siege::System::DSL::CommandSet.new)
      child_klass.instance_variable_set(:@instantiation_commands, Siege::System::DSL::CommandSet.new)
      Siege::System::DSL::Inheritance.inherit(base: self, child: child_klass)
      child_klass.singleton_class.prepend(ClassInheritance)
      super
    end
    # rubocop:enable Layout/LineLength
  end

  # @api private
  # @since 0.1.0
  module ClassMethods
    # @return [Siege::System::DSL::CommandSet]
    #
    # @api private
    # @since 0.1.0
    def definition_commands
      @definition_commands
    end

    # @return [Siege::System::DSL::CommandSet]
    #
    # @api private
    # @since 0.1.0
    def instantiation_commands
      @instantiation_commands
    end

    # @param name [String, Symbol]
    # @option loader [Class<Siege::System::Loader>, NilClass]
    # @param loader_definition [Block]
    # @return [void]
    #
    # @api public
    # @since 0.1.0
    def element(name, loader: nil, &loader_definition)
      definition_commands << Siege::System::DSL::Commands::Element.new(
        name, loader, loader_definition
      )
    end
  end
end
