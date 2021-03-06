# frozen_string_literal: true

# @api private
# @since 0.1.0
class Siege::System::Loader::Status
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

  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def initialize
    @lock = Siege::Core::Lock.new
    @current_status = INITIAL_STATUS
  end

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  def identifier
    @current_status
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def raw?
    thread_safe { current_status == NON_INITIALIZED }
  end

  # @param expression [Block]
  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  def transit_to_init(&expression)
    thread_safe do
      intercept_ambiguous_status_transition!(
        correct_initials: [NON_INITIALIZED, INITIALIZED],
        to: INITIALIZED
      )

      transactional(@current_status) do
        yield
        @current_status = INITIALIZED
      end
    end
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def initialized?
    thread_safe { current_status == INITIALIZED }
  end

  # @param expression [Block]
  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  def transit_to_start(&expression)
    thread_safe do
      intercept_ambiguous_status_transition!(
        correct_initials: [INITIALIZED, STOPPED, STARTED],
        to: STARTED
      )

      transactional(@current_status) do
        yield
        @current_status = STARTED
      end
    end
  end

  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def started?
    thread_safe { current_status == STARTED }
  end

  # @param expression [Block]
  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  def transit_to_stop(&expression)
    thread_safe do
      intercept_ambiguous_status_transition!(
        correct_initials: [STARTED, STOPPED],
        to: STOPPED
      )

      transactional(@current_status) do
        yield
        @current_status = STOPPED
      end
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

  # @return [Symbol]
  #
  # @api private
  # @since 0.1.0
  attr_reader :current_status

  # @param initial_status [Symbol]
  # @param transition [Block]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def transactional(initial_status, &transition)
    yield
  rescue => error
    @current_status = initial_status
    raise(error)
  end

  # @option correct_initials [Array<Symbol>]
  # @option to [Symbol]
  # @return [void]
  #
  # @api private
  # @since 0.1.0
  def intercept_ambiguous_status_transition!(correct_initials:, to:)
    unless correct_initials.include?(current_status)
      raise(Siege::System::AmbiguousElementStatusError, <<~ERROR_MESSAGE)
        :#{current_status} status can not be transitioned to :#{to} status!
        You can trasit to :#{to} status only from the one of #{correct_initials}!
      ERROR_MESSAGE
    end
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
