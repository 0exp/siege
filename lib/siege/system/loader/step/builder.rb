# frozen_string_literal: true

# @api private
# @since 0.1.0
module Siege::System::Loader::Step::Builder
  class << self
    # @param expression [Proc, NilClass]
    # @return [Siege::System::Loader::Step]
    #
    # @api private
    # @since 0.1.0
    def build(expression)
      Siege::System::Loader::Step.new(expression)
    end
  end
end
