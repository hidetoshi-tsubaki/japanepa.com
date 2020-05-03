require 'rails_helper'

RSpec.describe 'Admin::Events', type: :system do
  let!(:admin) { create(:admin) }
  let!(:event) { create(:event) }
  let!(:event_in_draft) { create(:event, status: 'draft') }
  let!(:last_event) { create(:event, :last_event) }
  let!(:date) { '2020-1-15'.to_date }

  context 'when signed in as admin' do
    before do
      admin_sign_in(admin.name, 'japanepa19')
      visit admin_events_path
    end

    it 'show event index page' do
      expect(page).to have_content event.name
      expect(page).to have_content last_event.name
    end

    it 'create event' do
      first(:link, "新規作成").click
      using_wait_time 15 do
        expect(page).to have_content 'New Event Form'
      end

      find('.start_time').set(date)
      find('.name_input').set('new-event')
      find('.detail_input').set('new-event-detail')
      click_on '新規作成'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content 'new-event'
    end

    it 'edit event' do
      first('.edit_btn').click
      using_wait_time 15 do
        expect(page).to have_content 'Edit Event Form'
      end
      find('.name_input').set('updated')
      click_on '編集'
      page.driver.browser.switch_to.alert.accept

      using_wait_time 10 do
        expect(page).to have_no_content 'Edit Event Form'
        expect(page).to have_content 'updated'
      end
    end

    it 'delete event' do
      first('.edit_btn').click
      using_wait_time 10 do
        find('.delete_btn').click
      end
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_no_content last_event.name
    end

    it 'delete event with ajax', js: true do
      expect(page).to have_content last_event.name
      first('.delete_btn').click
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_no_content last_event.name
    end

    describe 'Search event' do
      before do
        date = '2020-1-15'.to_date
        travel_to(date.prev_day(7)) do
          @event_7d_ago = create(:event, start_time: date.prev_day(7), end_time: date.prev_day(6))
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
          expect(page).to have_css '.fa-eye'
          expect(page).to have_content event.name
          expect(page).to have_no_css '.a-eye-slash'
          expect(page).to have_no_content event_in_draft.name
        end

        it 'search event by creation date' do
          find('.creation_date_from').set(date.prev_day(9).strftime("%Y/%m/%d"))
          find('.creation_date_to').set(date.prev_day(5).strftime("%Y/%m/%d"))
          click_button 'Search'
          expect(page).to have_content @event_7d_ago.name
          expect(page).to have_no_content event.name
        end

        it 'search event by update date' do
          find('.update_date_from').set(date.prev_day(9).strftime("%Y/%m/%d"))
          find('.update_date_to').set(date.prev_day(5).strftime("%Y/%m/%d"))
          click_button 'Search'
          expect(page).to have_content @event_7d_ago.name
          expect(page).to have_no_content event.name
        end

        it 'search event by start date' do
          find('.start_time_from').set(date.prev_day(9).strftime("%Y/%m/%d"))
          find('.start_time_to').set(date.prev_day(5).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_content @event_7d_ago.name
          expect(page).to have_no_content event.name
        end

        it 'search event by end date' do
          find('.end_time_from').set(date.prev_day(9).strftime("%Y/%m/%d"))
          find('.end_time_to').set(date.prev_day(5).strftime("%Y/%m/%d"))
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
          find('.creation_date_from').set(date.prev_day(30).strftime("%Y/%m/%d"))
          find('.creation_date_to').set(date.prev_day(20).strftime("%Y/%m/%d"))
          click_button 'Search'
          expect(page).to have_content 'No Events....'
          expect(page).to have_no_content event.name
        end

        it 'search event by updated date' do
          find('.update_date_from').set(date.prev_day(30).strftime("%Y/%m/%d"))
          find('.update_date_to').set(date.prev_day(20).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_content 'No Events....'
          expect(page).to have_no_content event.name
        end

        it 'search event by start date' do
          find('.start_time_from').set(date.prev_day(30).strftime("%Y/%m/%d"))
          find('.start_time_to').set(date.prev_day(20).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_content 'No Events....'
          expect(page).to have_no_content event.name
        end

        it 'search event by end date' do
          find('.end_time_from').set(date.prev_day(30).strftime("%Y/%m/%d"))
          find('.end_time_to').set(date.prev_day(20).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_content 'No Events....'
          expect(page).to have_no_content event.name
        end
      end
    end

    describe 'sort event' do
      it 'sort event by id' do
        click_on 'No.'
        within '.row_0' do
          expect(page).to have_content last_event.name
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
        within '.row_0' do
          expect(page).to have_content last_event.name
        end
      end

      it 'sort event by end time' do
        click_on 'End Time'
        within '.row_0' do
          expect(page).to have_content last_event.name
        end
      end

      it 'sort event by creation date' do
        click_on 'Creation Date'
        within '.row_0' do
          expect(page).to have_content last_event.name
        end
      end

      it 'sort event by update date' do
        click_on 'Update Date'
        within '.row_0' do
          expect(page).to have_content last_event.name
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
