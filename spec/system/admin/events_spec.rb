require 'rails_helper'

RSpec.describe 'Admin::Events', type: :system do
  let!(:admin) { create(:admin) }
  let!(:event) { create(:event) }
  let!(:event_in_draft) { create(:event, status: 'draft') }
  let!(:last_event) { create(:event, :last) }

  context 'when signed in as admin' do
    before do
      admin_sign_in(admin.name, 'japanepa')
      visit admin_events_path
    end

    it 'work correctly', js: true, retry: 2 do
      # 一覧表示
      expect(page).to have_content "イベント 一覧"
      expect(page).to have_content last_event.name

      # 新規作成
      first(:link, "New").click
      visit new_admin_event_path
      expect(page).to have_content 'Create Event'
      find('.start_time').set(Date.today)
      find('.name_input').set('new-event')
      find('.detail_input').set('new-event-detail')
      click_on '新規作成'
      page.driver.browser.switch_to.alert.accept
      visit admin_events_path
      expect(page).to have_content 'new-event'

      # 編集
      visit edit_admin_event_path event
      expect(page).to have_content 'Edit Event'
      find('.name_input').set('updated')
      click_on '編集'
      page.driver.browser.switch_to.alert.accept
      visit admin_events_path
      expect(page).to have_no_content 'Edit Event Form'
      expect(page).to have_content 'updated'

      # 削除
      visit edit_admin_event_path event
      find('.delete_btn').click
      page.driver.browser.switch_to.alert.accept
      visit admin_events_path
      expect(page).to have_no_content event.name

      # ajaxで削除
      expect(page).to have_content 'new-event'
      first('.delete_btn').click
      page.driver.browser.switch_to.alert.accept
      visit admin_events_path
      expect(page).to have_no_content 'new-event'
    end

    describe 'Search event' do
      before do
        travel_to(Date.today.prev_day(7)) do
          @event_7d_ago = create(:event, :oldest)
        end
        visit admin_events_path
      end

      context 'search by collect value' do
        it 'search event by word' do
          find('.keyword_search').set(event.name)
          click_on 'Search'
          expect(page).to have_content event.name
          expect(page).to have_no_content last_event.name
        end

        it 'search event by status' do
          expect(page).to have_content event.name
          find('#public_btn').click
          click_on 'Search'
          expect(page).to have_content event.name
          expect(page).to have_no_css '.a-eye-slash'
          expect(page).to have_no_content event_in_draft.name
        end

        it 'search event by creation date' do
          find('#creation_date_from').set(Date.today.prev_day(9).strftime("%Y/%m/%d"))
          find('#creation_date_to').set(Date.today.prev_day(5).strftime("%Y/%m/%d"))
          click_button 'Search'
          expect(page).to have_content @event_7d_ago.name
          expect(page).to have_no_content event.name
        end

        it 'search event by update date' do
          find('#update_date_from').set(Date.today.prev_day(9).strftime("%Y/%m/%d"))
          find('#update_date_to').set(Date.today.prev_day(5).strftime("%Y/%m/%d"))
          click_button 'Search'
          expect(page).to have_content @event_7d_ago.name
          expect(page).to have_no_content event.name
        end

        it 'search event by start date' do
          find('#start_time_from').set(Date.today.prev_day(9).strftime("%Y/%m/%d"))
          find('#start_time_to').set(Date.today.prev_day(5).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_content @event_7d_ago.name
          expect(page).to have_no_content event.name
        end

        it 'search event by end date' do
          find('#end_time_from').set(Date.today.prev_day(9).strftime("%Y/%m/%d"))
          find('#end_time_to').set(Date.today.prev_day(5).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_content @event_7d_ago.name
          expect(page).to have_no_content event.name
        end
      end

      context 'search by incollect value' do
        it 'search event by word' do
          find('.keyword_search').set('wrong-word')
          click_on 'Search'
          expect(page).to have_content 'No Events....'
          expect(page).to have_no_content event.name
        end

        it 'search event by creation date' do
          find('#creation_date_from').set(Date.today.prev_day(30).strftime("%Y/%m/%d"))
          find('#creation_date_to').set(Date.today.prev_day(20).strftime("%Y/%m/%d"))
          click_button 'Search'
          expect(page).to have_content 'No Events....'
          expect(page).to have_no_content event.name
        end

        it 'search event by updated date' do
          find('#update_date_from').set(Date.today.prev_day(30).strftime("%Y/%m/%d"))
          find('#update_date_to').set(Date.today.prev_day(20).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_content 'No Events....'
          expect(page).to have_no_content event.name
        end

        it 'search event by start date' do
          find('#start_time_from').set(Date.today.prev_day(30).strftime("%Y/%m/%d"))
          find('#start_time_to').set(Date.today.prev_day(20).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_content 'No Events....'
          expect(page).to have_no_content event.name
        end

        it 'search event by end date' do
          find('#end_time_from').set(Date.today.prev_day(30).strftime("%Y/%m/%d"))
          find('#end_time_to').set(Date.today.prev_day(20).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_content 'No Events....'
          expect(page).to have_no_content event.name
        end
      end
    end

    describe 'sort event' do
      before do
        travel_to(Date.tomorrow) do
          @latest_event = create(:event, name: 'latest', start_time: Date.tomorrow, end_time: Date.tomorrow)
        end
      end

      it 'sort event by id' do
        click_on 'No.'
        within '.row_0' do
          expect(page).to have_content @latest_event.name
        end
      end

      it 'sort event by name' do
        click_on 'Name' do
          within '.row_0' do
            expect(page).to have_content last_event.name
          end
        end
      end

      it 'sort event by views' do
        click_on 'Views'
        within '.row_0' do
          expect(page).to have_content last_event.name
        end
      end

      it 'sort event by start time' do
        click_on 'Start Time'
        using_wait_time 20 do
          within '.row_0' do
            expect(page).to have_content @latest_event.name
          end
        end
      end

      it 'sort event by end time' do
        click_on 'End Time'
        within '.row_0' do
          expect(page).to have_content @latest_event.name
        end
      end

      it 'sort event by creation date' do
        click_on 'Creation Date'
        within '.row_0' do
          expect(page).to have_content @latest_event.name
        end
      end

      it 'sort event by update date' do
        click_on 'Update Date'
        within '.row_0' do
          expect(page).to have_content @latest_event.name
        end
      end
    end
  end

  context 'when does not signed as admin user' do
    it 'can not access to admin event page as admin user' do
      visit admin_events_path
      expect(page).to have_no_content 'Events Index'
    end

    it 'can not access to create event page as admin user' do
      visit new_admin_event_path
      expect(page).to have_no_content 'Events Index'
    end

    it 'can not access to edit event page as admin user' do
      visit edit_admin_event_path event
      expect(page).to have_no_content 'Event Index'
    end
  end
end
