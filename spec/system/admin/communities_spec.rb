require 'rails_helper'

RSpec.describe 'Admin::Communities', type: :system do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:community) { create(:community, founder_id: user.id) }
  let!(:last_community) { create(:community, :last) }
  let!(:last_user) { create(:user, name: 'WWW user') }
  let!(:talk) { create(:talk, community_id: last_community.id) }
  let!(:community_user) { create(:community_user, community_id: last_community.id) }
  let!(:date) { '2020-1-15'.to_date }

  context 'when signed in as admin user' do
    before do
      admin_sign_in(admin.name, 'japanepa19')
      visit admin_communities_path
    end

    it 'show communiteis index page' do
      expect(page).to have_content community.name
      expect(page).to have_content last_community.name
    end

    it 'delete community with ajax', js: true do
      page.first('.delete_btn').click
      page.driver.browser.switch_to.alert.accept
      using_wait_time 10 do
        expect(page).to have_no_content last_community.name
      end
    end

    describe 'search community' do
      before do
        travel_to('2020-1-8') do
          @community_7days_ago = create(:community, name: '7days_ago')
        end
      end

      context 'search community by collect values' do
        it 'search community by word' do
          expect(page).to have_content community.name
          find(".keyword_search").set(community.name)
          click_on 'Search'
          expect(page).to have_content community.name
          expect(page).to have_no_content last_community.name
        end

        it 'search community by creation date' do
          find('.creation_date_from').set(date.prev_day(9).strftime("%Y/%m/%d"))
          find('.creation_date_to').set(date.prev_day(6).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_content @community_7days_ago.name
          expect(page).to have_no_content community.name
        end

        it 'search community by updated date' do
          find('.update_date_from').set(date.prev_day(9).strftime("%Y/%m/%d"))
          find('.update_date_to').set(date.prev_day(6).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_content @community_7days_ago.name
          expect(page).to have_no_content community.name
        end
      end

      context 'search community by incollect values' do
        it 'search community by word' do
          find(".keyword_search").set('wrong-name')
          click_on 'Search'
          expect(page).to have_no_content community.name
          expect(page).to have_content 'No communities....'
        end

        it 'search community by creation date' do
          find('.creation_date_from').set(date.prev_day(20).strftime("%Y/%m/%d"))
          find('.creation_date_to').set(date.prev_day(30).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_no_content @community_7days_ago.name
          expect(page).to have_content 'No communities....'
        end

        it 'search community by update date' do
          find('.update_date_from').set(date.prev_day(20).strftime("%Y/%m/%d"))
          find('.update_date_to').set(date.prev_day(30).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_no_content @community_7days_ago.name
          expect(page).to have_content 'No communities....'
        end
      end
    end
  end

  describe 'sort community' do
    before do
      admin_sign_in(admin.name, 'japaanepa19')
      visit admin_communities_path
    end

    it 'sort community by id' do
      click_on 'No.'
      within '.row_0' do
        expect(page).to have_content last_community.name
      end
    end

    it 'sort community by name' do
      click_on 'Name'
      within '.row_0' do
        expect(page).to have_content last_community.name
      end
    end

    it 'sort community by member' do
      click_on 'Members'
      within '.row_0' do
        expect(page).to have_content last_community.name
      end
    end

    it 'sort community by talks' do
      within ".index_head" do
        click_on 'Talks'
      end
      within '.row_0' do
        expect(page).to have_content last_community.name
      end
    end

    it 'sort community by introduction' do
      click_on 'Introduction'
      within '.row_0' do
        expect(page).to have_content last_community.name
      end
    end

    it 'sort community by founder' do
      click_on 'Founder'
      within '.row_0' do
        expect(page).to have_content last_community.name
      end
    end

    it 'sort community by create date' do
      click_on 'Creation Date'
      within '.row_0' do
        expect(page).to have_content last_community.name
      end
    end

    it 'sort community by update date' do
      click_on 'Update Date'
      within '.row_0' do
        expect(page).to have_content last_community.name
      end
    end
  end

  context 'when does not signed in as admin user' do
    it 'can not access to admin community index page as admin user' do
      visit admin_communities_path
      expect(page).to have_no_content 'Community index'
    end
  end
end
