require 'rails_helper'

RSpec.describe 'Admin::Announcement', type: :system do
  let!(:admin) { create(:admin) }
  let!(:announce) { create(:announcement) }
  let!(:announce_in_draft) { create(:announcement, status: 'draft') }
  let!(:last_announce) { create(:announcement, :last) }

  context 'when signed in as admin' do
    before do
      admin_sign_in(admin.name, 'japanepa')
      visit admin_announcements_path
    end

    it 'show announce index page' do
      expect(page).to have_content announce.title
      expect(page).to have_content last_announce.title
    end

    it 'create announce', retry: 3 do
      first(:link, "New").click
      using_wait_time 15 do
        expect(page).to have_content 'Create Announce'
      end
      find('#title_input').set('new-announce')
      find('#contents_input').set('new-contents')
      click_on '新規作成'
      using_wait_time 25 do
        page.driver.browser.switch_to.alert.accept
      end

      expect(page).to have_content 'new-announce'
    end

    it 'edit announce', retry: 3 do
      first('.edit_btn').click
      using_wait_time 10 do
        expect(page).to have_content 'Edit Announcement'
      end
      find('#title_input').set('update-announce')
      click_on '編集'
      using_wait_time 25 do
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'update-announce'
        expect(page).to have_no_content last_announce.title
      end
    end

    it 'delete announce' do
      expect(page).to have_content last_announce.title
      visit edit_admin_announcement_path last_announce
      find('.delete_btn').click
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_no_content last_announce.title
    end

    it 'delete announce with ajax', js: true do
      expect(page).to have_content last_announce.title
      first('.delete_btn').click
      page.driver.browser.switch_to.alert.accept
      using_wait_time 15 do
        expect(page).to have_no_content last_announce.title
      end
    end

    describe 'Search announce' do
      before do
        travel_to(Date.today.prev_day(7)) do
          @announce_7days_ago = create(:announcement, title: '7days_ago')
        end
        visit admin_announcements_path
      end

      context 'search by collect value' do
        it 'search announce by word' do
          find('.keyword_search').set(announce.title)
          click_on 'Search'
          expect(page).to have_content announce.title
          expect(page).to have_no_content last_announce.title
        end

        it 'search announce by status' do
          expect(page).to have_content announce.title
          find('#public_btn').click
          click_on 'Search'
          expect(page).to have_content announce.title
          expect(page).to have_no_css '.a-eye-slash'
          expect(page).to have_no_content announce_in_draft.title
        end

        it 'search announce by creation date' do
          find('#creation_date_from').set(Date.today.prev_day(9).strftime("%Y/%m/%d"))
          find('#creation_date_to').set(Date.today.prev_day(5).strftime("%Y/%m/%d"))
          click_button 'Search'
          expect(page).to have_content @announce_7days_ago.title
          expect(page).to have_no_content announce.title
        end

        it 'search announce by update date' do
          find('#update_date_from').set(Date.today.prev_day(9).strftime("%Y/%m/%d"))
          find('#update_date_to').set(Date.today.prev_day(5).strftime("%Y/%m/%d"))
          click_button 'Search'
          expect(page).to have_content @announce_7days_ago.title
          expect(page).to have_no_content announce.title
        end
      end

      context 'search by incollect value' do
        it 'search announce by word' do
          find('.keyword_search').set('wrong-word')
          click_on 'Search'
          expect(page).to have_content 'No announcement....'
          expect(page).to have_no_content announce.title
        end

        it 'search announce by creation date' do
          find('#creation_date_from').set(Date.today.prev_day(30).strftime("%Y/%m/%d"))
          find('#creation_date_to').set(Date.today.prev_day(20).strftime("%Y/%m/%d"))
          click_button 'Search'
          expect(page).to have_content 'No announcement....'
          expect(page).to have_no_content announce.title
        end

        it 'search announce by updated date' do
          find('#update_date_from').set(Date.today.prev_day(30).strftime("%Y/%m/%d"))
          find('#update_date_to').set(Date.today.prev_day(20).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_content 'No announcement....'
          expect(page).to have_no_content announce.title
        end
      end
    end

    describe 'sort announce' do
      it 'sort announce by id' do
        click_on 'No.'
        within '.row_0' do
          expect(page).to have_content last_announce.title
        end
      end

      it 'sort announce by title' do
        click_on 'Title' do
          within '.row_0' do
            expect(page).to have_content last_announce.title
          end
        end
      end

      it 'sort announce by views' do
        click_on 'Views'
        within '.row_0' do
          expect(page).to have_content last_announce.title
        end
      end

      it 'sort announce by creation date' do
        click_on 'Creation Date'
        within '.row_0' do
          expect(page).to have_content last_announce.title
        end
      end

      it 'sort announce by update date' do
        click_on 'Update Date'
        within '.row_0' do
          expect(page).to have_content last_announce.title
        end
      end
    end
  end

  context 'when does not signed as admin user' do
    it 'can not access to admin announce page as admin user' do
      visit admin_announcements_path
      expect(page).to have_no_content 'お知らせ一覧'
    end

    it 'can not access to create announce page as admin user' do
      visit new_admin_announcement_path
      expect(page).to have_no_content 'お知らせ一覧'
    end

    it 'can not access to edit announce page as admin user' do
      visit edit_admin_announcement_path announce
      expect(page).to have_no_content 'お知らせ一覧'
    end
  end
end
