# frozen_string_literal: true

# @api private
# @since 0.1.0
module Siege::System::DSL::Inheritance
  class << self
    # @option base [Class<Siege::System>]
    # @option child [Class<Siege::System>]
    #
    # @api private
    # @since 0.1.0
    def inherit(base:, child:)
      child.definition_commands.concat(base.definition_commands, &:inheritable?)
      child.instantiation_commands.concat(base.instantiation_commands, &:inheritable?)
    end
  end
end
