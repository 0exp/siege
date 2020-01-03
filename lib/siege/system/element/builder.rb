# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Element::Builder
  class << self
    # @param element_klass [Class<Siege::System::Element>]
    # @return [Siege::System::Element]
    #
    # @api private
    # @since 0.1.0
    def build(element_klass)
      new(element_klass).build
    end
  end

  # @param element_klass [Class<Siege::System::Element>]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(element_klass)
    @element_klass = element_klass
  end

  # @return [Siege::System::Element]
  #
  # @api private
  # @since 0.1.0
  def build; end

  private

  # @return [Class<Siege::System::Element>]
  #
  # @api private
  # @since 0.1.0
  attr_reader :element_klass
end
