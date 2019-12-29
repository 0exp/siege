# frozen_string_literal: true

RSpec.describe 'Siege Version' do
  specify { expect(Siege::VERSION).to eq('0.0.0') }
end
