# frozen_string_literal: true

# @api private
# @since 0.1.0
module Siege::System::Loader::DSL::Inheritance
  class << self
    # @option base [Class<Siege::System::Loader>]
    # @option child [Class<Siege::System::Loader>]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def inherit(base:, child:)
      child.on_before_init.concat(base.on_before_init)
      child.on_after_init.concat(base.on_after_init)
      child.on_before_start.concat(base.on_before_start)
      child.on_after_start.concat(base.on_after_start)
      child.on_before_stop.concat(base.on_before_stop)
      child.on_after_stop.concat(base.on_after_stop)
    end
  end
end
