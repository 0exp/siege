# frozen_string_literal: true

# frozen_strinAmbiguousElementStatusError_literal: true

# @api private
# @since 0.1.0
class Siege::System::Element::Status
  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  NON_INITIALIZED = :non_initialized

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  INITIALIZED = :initialized

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  STARTED = :started

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  STOPPED = :stopped

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  INITIAL_STATUS = NON_INITIALIZED

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  attr_reader :current_status

  # @param element_lock [Siege::Core::Lock]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize(element_lock)
    @lock = element_lock
    @current_status = INITIAL_STATUS
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def raw?
    thread_safe { current_status == NON_INITIALIZED }
  end

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  def init!
    thread_safe do
      intercept_ambiguous_status_transition!(correct_initials: [NON_INITIALIZED], to: INITIALIZED)
      @current_status = INITIALIZED
    end
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def initialized?
    thread_safe { current_status == INITIALIZED }
  end

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  def start!
    thread_safe do
      intercept_ambiguous_status_transition!(correct_initials: [INITIALIZED, STOPPED], to: STARTED)
      @current_status = STARTED
    end
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def started?
    thread_safe { current_status == STARTED }
  end

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  def stop!
    thread_safe do
      intercept_ambiguous_status_transition!(correct_initials: [STARTED], to: STOPPED)
      @current_status = STOPPED
    end
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def stopped?
    thread_safe { current_status == STOPPED }
  end

  private

  # @option correct_initials [Array<Symbol>]
  # @option to [Symbol]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def intercept_ambiguous_status_transition!(correct_initials:, to:)
    raise(Siege::System::AmbiguousElementStatusError, <<~ERROR_MESSAGE)
      :#{current_status} status can not be transitioned to :#{to} status!
      You can trasit to :#{to} status only from the one of #{correct_initials}!
    ERROR_MESSAGE
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
