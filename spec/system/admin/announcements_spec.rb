require 'rails_helper'

RSpec.describe 'Admin::Announcement', type: :system do
  let!(:admin) { create(:admin) }
  let!(:announce) { create(:announcement) }
  let!(:announce_in_draft) { create(:announcement, status: 'draft', title: "draft") }
  let!(:last_announce) { create(:announcement, :last) }

  context 'when signed in as admin' do
    before do
      admin_sign_in(admin.name, 'japanepa')
      visit admin_announcements_path
    end

    it 'work correctly', js: true, retry: 2 do
      # 一覧表示
      expect(page).to have_content announce.title
      expect(page).to have_content last_announce.title

      # 新規作成
      visit new_admin_announcement_path
      find('#title_input').set('new-announce')
      find('#contents_input').set('new-contents')
      click_on '新規作成'
      using_wait_time 10 do
        page.driver.browser.switch_to.alert.accept
      end
      expect(page).to have_content 'new-announce'

      # 編集
      visit edit_admin_announcement_path announce
      expect(page).to have_content 'Edit Announcement'
      find('#title_input').set('update-announce')
      click_on '編集'
      using_wait_time 10 do
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'update-announce'
      end

      # 削除
      expect(page).to have_content last_announce.title
      visit edit_admin_announcement_path last_announce
      expect(page).to have_content "Edit Announcement"
      expect(page).to have_content last_announce.title
      find('.delete_btn').click
      page.driver.browser.switch_to.alert.accept
      visit admin_announcements_path
      expect(page).to have_no_content last_announce.title

      # ajaxで削除
      expect(page).to have_content "new-announce"
      first('.delete_btn').click
      page.driver.browser.switch_to.alert.accept
      using_wait_time 15 do
        expect(page).to have_no_content "new_announce"
      end
    end

    describe 'Search announce' do
      before do
        travel_to(Date.today.prev_day(7)) do
          @announce_7days_ago = create(:announcement, title: '7days_ago')
        end
      end

      context 'search by correct value' do
        it 'show correct articles' do
          # タイトルで検索
          find('.keyword_search').set(announce.title)
          click_on 'Search'
          expect(page).to have_content announce.title
          expect(page).to have_no_content last_announce.title

          # 公開状況で検索
          expect(page).to have_content announce.title
          find('#public_btn').click
          click_on 'Search'
          expect(page).to have_content announce.title
          expect(page).to have_no_css '.a-eye-slash'
          expect(page).to have_no_content announce_in_draft.title
        end
      end

      context 'search by incorrect value' do
        it 'show no announcement' do
          # タイトルで検索
          find('.keyword_search').set('wrong-word')
          click_on 'Search'
          expect(page).to have_content 'No announcement....'
          expect(page).to have_no_content announce.title

          # 作成日で検索
          find('#creation_date_from').set(Date.today.prev_day(30).strftime("%Y/%m/%d"))
          find('#creation_date_to').set(Date.today.prev_day(20).strftime("%Y/%m/%d"))
          click_button 'Search'
          expect(page).to have_content 'No announcement....'
          expect(page).to have_no_content announce.title

          # 更新日で検索
          find('#update_date_from').set(Date.today.prev_day(30).strftime("%Y/%m/%d"))
          find('#update_date_to').set(Date.today.prev_day(20).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_content 'No announcement....'
          expect(page).to have_no_content announce.title
        end
      end
    end

    describe 'sort announce' do
      before do
        travel_to(Date.tomorrow) do
          @latest_announce = create(:announcement, title: 'latest')
        end
      end

      it 'can sort by id', retry: 2 do
        click_on 'No.'
        within '.row_0' do
          expect(page).to have_content @latest_announce.title
        end
      end

      it 'can sort by title' do
        click_on 'Title'
        within '.row_0' do
          expect(page).to have_content last_announce.title
        end
      end

      it 'can sort by view' do
        click_on 'Views'
        within '.row_0' do
          expect(page).to have_content last_announce.title
        end
      end

      it 'can sort by creation date', retry: 2 do
        click_on 'Creation Date'
        within '.row_0' do
          expect(page).to have_content @latest_announce.title
        end
      end

      it 'can sort by update date', retry: 2 do
        click_on 'Update Date'
        within '.row_0' do
          expect(page).to have_content @latest_announce.title
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
