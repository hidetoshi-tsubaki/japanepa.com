require 'rails_helper'

RSpec.describe 'Events', type: :system do
  let!(:user) { create(:user) }
  let!(:event) { create(:event, start_time: Date.today, end_time: Date.today) }

  before do
    user_sign_in(user.name, 'password')
    visit events_path user
  end

  it 'All function work normally' do
    # イベントが表示される
    expect(page).to have_content 'event1'
    expect(page).to have_css '.event_1'
  end
end
