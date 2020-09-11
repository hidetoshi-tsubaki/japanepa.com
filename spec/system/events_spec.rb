require 'rails_helper'

RSpec.describe 'Events', type: :system do
  let!(:user) { create(:user, :with_related_model) }
  let!(:event) { create(:event, start_time: Date.today, end_time: Date.today) }
  let!(:event2) { create(:event, start_time: Date.today, end_time: Date.today, status: "draft") }

  it 'All function work normally', retry: 2 do
    user_sign_in(user.name, 'japanepa')
    visit events_path user

    # event 一覧
    expect(page).to have_content event.name

    # 非公開のeventは表示されない
    expect(page).to have_no_content event2.name

    # event 詳細表示
    first(:link, event.name).click
    using_wait_time 20 do
      expect(page).to have_content event.detail
    end
  end
end
