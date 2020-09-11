require 'rails_helper'

RSpec.describe 'Admin::Communities', type: :system do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:community) { create(:community, founder_id: user.id) }
  let!(:last_founder) { create(:user, name: "wwww") }
  let!(:last_community) { create(:community, :last, founder_id: last_founder.id) }

  context 'when signed in as admin user' do
    before do
      admin_sign_in(admin.name, 'japanepa')
      visit admin_communities_path
    end

    it 'work correctly', js: true, retry: 2 do
      # 一覧表示
      expect(page).to have_content community.name
      expect(page).to have_content last_community.name

      # ajaxで削除
      within "#community_#{last_community.id}" do
        first('.delete_btn').click
      end
      page.driver.browser.switch_to.alert.accept
      visit admin_communities_path
      expect(page).to have_no_content last_community.name
    end

    describe 'search community' do
      before do
        travel_to(Date.today.prev_day(7)) do
          @community_7days_ago = create(:community, :with_founder, name: '7days_ago')
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
          find('#creation_date_from').set(Date.today.prev_day(9).strftime("%Y/%m/%d"))
          find('#creation_date_to').set(Date.today.prev_day(6).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_content @community_7days_ago.name
          expect(page).to have_no_content community.name
        end

        it 'search community by updated date' do
          find('#update_date_from').set(Date.today.prev_day(9).strftime("%Y/%m/%d"))
          find('#update_date_to').set(Date.today.prev_day(6).strftime("%Y/%m/%d"))
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
          find('#creation_date_from').set(Date.today.prev_day(20).strftime("%Y/%m/%d"))
          find('#creation_date_to').set(Date.today.prev_day(30).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_no_content @community_7days_ago.name
          expect(page).to have_content 'No communities....'
        end

        it 'search community by update date' do
          find('#update_date_from').set(Date.today.prev_day(20).strftime("%Y/%m/%d"))
          find('#update_date_to').set(Date.today.prev_day(30).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_no_content @community_7days_ago.name
          expect(page).to have_content 'No communities....'
        end
      end
    end

    describe 'sort community' do
      before do
        travel_to(Date.tomorrow) do
          @latest_community = create(:community, :with_founder, name: 'latest')
        end
      end

      it 'sort community by id', retry: 2 do
        click_on 'No.'
        within '.row_0' do
          expect(page).to have_content @latest_community.name
        end
      end

      it 'sort community by name', retry: 2 do
        click_on 'Name'
        within '.row_0' do
          expect(page).to have_content last_community.name
        end
      end

      it 'sort community by member', retry: 2 do
        click_on 'Members'
        within '.row_0' do
          expect(page).to have_content last_community.name
        end
      end

      it 'sort community by talks', retry: 2 do
        click_on 'Talks'
        within '.row_0' do
          expect(page).to have_content last_community.name
        end
      end

      it 'sort community by introduction', retry: 2 do
        click_on 'Introduction'
        within '.row_0' do
          expect(page).to have_content last_community.name
        end
      end

      it 'sort community by founder', retry: 2 do
        click_on 'Founder'
        within '.row_0' do
          expect(page).to have_content last_community.name
        end
      end

      it 'sort community by create date', retry: 2 do
        click_on 'Creation Date'
        within '.row_0' do
          expect(page).to have_content @latest_community.name
        end
      end

      it 'sort community by update date', retry: 2 do
        click_on 'Update Date'
        within '.row_0' do
          expect(page).to have_content @latest_community.name
        end
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
