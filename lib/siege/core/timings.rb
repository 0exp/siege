# frozen_string_literal: true

# @api public
# @since 0.1.0
module Siege::Core::Timings
  module_function

  # @return [Float]
  #
  # @api public
  # @since 0.1.0
  def current_time
    Time.now
  end
end
