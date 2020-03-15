# frozen_string_literal: true

require 'securerandom'

# @api public
# @since 0.1.0
module Siege::Core::Randomizer
  # @return [String]
  #
  # @api public
  # @since 0.1.0
  def uuid
    SecureRandom.uuid
  end
end
