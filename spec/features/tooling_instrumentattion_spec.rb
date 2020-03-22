# frozen_string_literal: true

RSpec.describe 'Instrumentation subsystem' do
  let(:instrumenter) { Siege::Tooling::Instrumentation.build_instance }
  let(:time_moment) { Time.utc(2020, 1, 1, 0, 0, 0) }

  before { Timecop.freeze(time_moment) }

  specify 'subscribe and notify' do
    subscriber_1_data_store = [] # <-- user.updated, user.created, system.fail
    subscriber_2_data_store = [] # <-- user.created
    subscriber_3_data_store = [] # <-- user.created, user.updated

    # generic event
    instrumenter.subscribe('*') do |event|
      subscriber_1_data_store << event.to_h
    end

    # specific event
    instrumenter.subscribe('user.created') do |event|
      subscriber_2_data_store << event.to_h
    end

    # group of events
    instrumenter.subscribe('user.#') do |event|
      subscriber_3_data_store << event.to_h
    end

    instrumenter.instrument('user.updated') do |payload:, metadata:|
      payload[:user_id] = 1
      metadata[:is_admin] = false
    end

    instrumenter.instrument('user.created') do |payload:, metadata:|
      payload[:some_data] = 1
      metadata[:some_metadata] = 2
    end

    instrumenter.instrument('system.fail')

    expect(subscriber_1_data_store).to containing_exactly(
      a_hash_including(
        id: be_a(String),
        name: 'user.updated',
        start_time: time_moment,
        end_time: time_moment,
        payload: { user_id: 1 },
        metadata: { is_admin: false }
      ),
      a_hash_including(
        id: be_a(String),
        name: 'user.created',
        start_time: time_moment,
        end_time: time_moment,
        payload: { some_data: 1 },
        metadata: { some_metadata: 2 }
      ),
      a_hash_including(
        id: be_a(String),
        name: 'system.fail',
        start_time: time_moment,
        end_time: time_moment,
        payload: {},
        metadata: {}
      )
    )

    expect(subscriber_2_data_store).to containing_exactly(
      a_hash_including(
        id: be_a(String),
        name: 'user.created',
        start_time: time_moment,
        end_time: time_moment,
        payload: { some_data: 1 },
        metadata: { some_metadata: 2 }
      )
    )

    expect(subscriber_3_data_store).to containing_exactly(
      a_hash_including(
        id: be_a(String),
        name: 'user.created',
        start_time: time_moment,
        end_time: time_moment,
        payload: { some_data: 1 },
        metadata: { some_metadata: 2 }
      ),
      a_hash_including(
        id: be_a(String),
        name: 'user.updated',
        start_time: time_moment,
        end_time: time_moment,
        payload: { user_id: 1 },
        metadata: { is_admin: false }
      )
    )
  end
end
