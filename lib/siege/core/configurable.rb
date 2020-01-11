# frozen_string_literal: true

require 'qonfig'

# @api public
# @since 0.1.0
module Siege::Core::Configurable
  class << self
    # @base_klass [Class]
    # @return [void]
    #
    # @api private
    # @since 0.1.0
    def included(base_klass)
      base_klass.include(Qonfig::Configurable)
    end
  end
end
