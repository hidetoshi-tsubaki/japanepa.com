require 'rails_helper'
require 'date'

RSpec.describe 'Admin::Users', type: :system do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:last_user) { create(:user, name: 'zzz_last_user', country: 'ZW', current_address: 'ZW') }
  let!(:community) { create(:community, founder_id: user.id) }
  let!(:date) { '2020-1-15'.to_date }

  before do
    create_list(:level, 10)
  end

  context 'when signed in as admin' do
    before do
      admin_sign_in(admin.name, 'japanepa19')
      visit admin_users_path
    end

    it 'show users index page' do
      expect(page).to have_content user.name
      expect(page).to have_content user2.name
    end

    it 'show user detail page' do
      visit admin_user_path(user)
      expect(page).to have_content user.name
      expect(page).to have_no_content user2.name
    end
  end

  context 'when does not sigend in as admin' do
    it 'can not access to admin users index' do
      visit admin_user_path(user)
      expect(page).to have_no_content user.name
    end
  end

  describe 'search user' do
    before do
      admin_sign_in(admin.name, 'japanepa19')
      visit admin_users_path
      travel_to('2020-1-8') do
        @user_7days_old = create(:user, name: '7days_ago')
      end
    end

    context 'search user by collect values' do
      it 'search user by word' do
        expect(page).to have_content user2.name
        fill_in 'keyword_search', with: user.name
        click_on 'Search'
        expect(page).to have_content user.name
        expect(page).to have_no_content user2.name
      end

      it 'search user by country' do
        expect(page).to have_content user2.name
        select 'Japan', from: 'q[country_eq]'
        click_on 'Search'
        expect(page).to have_content user.name
        expect(page).to have_no_content last_user.name
      end

      it 'search user by address' do
        expect(page).to have_content user2.name
        select 'Japan', from: 'q[current_address_eq]'
        click_on 'Search'
        expect(page).to have_content user.name
        expect(page).to have_no_content last_user.name
      end

      it 'search user by creation date' do
        find('.creation_date_from').set(date.prev_day(9).strftime("%Y/%m/%d"))
        find('.creation_date_to').set(date.prev_day(6).strftime("%Y/%m/%d"))
        click_on 'Search'
        expect(page).to have_no_content user.name
        expect(page).to have_content @user_7days_old.name
      end
    end

    context 'search user by incollect values' do
      it 'search user by wrong keyword' do
        fill_in 'keyword_search', with: 'wrong keyword'
        click_on 'Search'
        expect(page).to have_content 'No users....'
      end
    end
  end

  describe 'sort user' do
    before do
      create(:community_user, user_id: last_user.id, community_id: community.id)
      create(:talk, user_id: last_user.id, community_id: community.id)
      admin_sign_in(admin.name, 'japanepa19')
      visit admin_users_path
    end

    it 'sort user by id' do
      click_on 'No.'
      within '.row_0' do
        expect(page).to have_content last_user.name
      end
    end

    it 'sort user by name' do
      click_on 'Name'
      within '.row_0' do
        expect(page).to have_content last_user.name
      end
    end

    it 'sort user by community' do
      click_on 'community'
      within '.row_0' do
        expect(page).to have_content last_user.name
      end
    end

    it 'sort user by talks' do
      click_on 'talks'
      within '.row_0' do
        expect(page).to have_content last_user.name
      end
    end
  end
end
