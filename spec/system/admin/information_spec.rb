require 'rails_helper'

RSpec.describe 'Admin::information', type: :system do
  let!(:admin) { create(:admin) }
  let!(:info) { create(:information) }
  let!(:info_in_draft) { create(:information, status: 'draft') }
  let!(:last_info) { create(:information, :last_info) }
  let!(:date) { '2020-1-15'.to_date }

  context 'when signed in as admin' do
    before do
      admin_sign_in(admin.name, 'japanepa19')
      visit admin_information_index_path
    end

    it 'show info index page' do
      expect(page).to have_content info.title
      expect(page).to have_content last_info.title
    end

    it 'create info' do
      first(:link, "新規作成").click
      using_wait_time 15 do
        expect(page).to have_content 'New Information Form'
      end
      find('.title_input').set('new-info')
      find('.contents_input').set('new-info')
      click_on '新規作成'
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content 'new-info'
    end

    it 'edit info' do
      first('.edit_btn').click
      using_wait_time 10 do
        expect(page).to have_content 'Edit Information Form'
      end
      find('.title_input').set('new-info')
      click_on '編集'
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content 'new-info'
      expect(page).to have_content info.title
    end

    it 'delete info' do
      expect(page).to have_content last_info.title
      visit edit_admin_information_path last_info
      find('.delete_btn').click
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_no_content last_info.title
    end

    it 'delete info with ajax', js: true do
      expect(page).to have_content info.title
      first('.delete_btn').click
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_no_content last_info.title
    end

    describe 'Search info' do
      before do
        @date = '2020-1-15'.to_date
        travel_to(@date.prev_day(7)) do
          @info_7days_ago = create(:information, title: '7days_ago')
        end
        visit admin_information_index_path
      end

      context 'search by collect value' do
        it 'search info by word' do
          find('.keyword_search').set(info.title)
          click_on 'Search'
          expect(page).to have_content info.title
          expect(page).to have_no_content last_info.title
        end

        it 'search info by status' do
          expect(page).to have_content info.title
          find('#public_btn').click
          click_on 'Search'
          expect(page).to have_css '.fa-eye'
          expect(page).to have_content info.title
          expect(page).to have_no_css '.a-eye-slash'
          expect(page).to have_no_content info_in_draft.title
        end

        it 'search info by creation date' do
          find('.creation_date_from').set(date.prev_day(9).strftime("%Y/%m/%d"))
          find('.creation_date_to').set(date.prev_day(5).strftime("%Y/%m/%d"))
          click_button 'Search'
          expect(page).to have_content @info_7days_ago.title
          expect(page).to have_no_content info.title
        end

        it 'search info by update date' do
          find('.update_date_from').set(date.prev_day(9).strftime("%Y/%m/%d"))
          find('.update_date_to').set(date.prev_day(5).strftime("%Y/%m/%d"))
          click_button 'Search'
          expect(page).to have_content @info_7days_ago.title
          expect(page).to have_no_content info.title
        end
      end

      context 'search by incollect value' do
        it 'search info by word' do
          find('.keyword_search').set('wrong-word')
          click_on 'Search'
          expect(page).to have_content 'No information....'
          expect(page).to have_no_content info.title
        end

        it 'search info by creation date' do
          find('.creation_date_from').set(@date.prev_day(30).strftime("%Y/%m/%d"))
          find('.creation_date_to').set(@date.prev_day(20).strftime("%Y/%m/%d"))
          click_button 'Search'
          expect(page).to have_content 'No information....'
          expect(page).to have_no_content info.title
        end

        it 'search info by updated date' do
          find('.update_date_from').set(@date.prev_day(30).strftime("%Y/%m/%d"))
          find('.update_date_to').set(@date.prev_day(20).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_content 'No information....'
          expect(page).to have_no_content info.title
        end
      end
    end

    describe 'sort info' do
      it 'sort info by id' do
        click_on 'No.'
        within '.row_0' do
          expect(page).to have_content last_info.title
        end
      end

      it 'sort info by title' do
        click_on 'Title' do
          within '.row_0' do
            expect(page).to have_content last_info.title
          end
        end
      end

      it 'sort ino by views' do
        click_on 'Views'
        within '.row_0' do
          expect(page).to have_content last_info.title
        end
      end

      it 'sort info by creation date' do
        click_on 'Creation Date'
        within '.row_0' do
          expect(page).to have_content last_info.title
        end
      end

      it 'sort info by update date' do
        click_on 'Update Date'
        within '.row_0' do
          expect(page).to have_content last_info.title
        end
      end
    end
  end

  context 'when does not signed as admin user' do
    it 'can not access to admin info page as admin user' do
      visit admin_information_index_path
      expect(page).to have_no_content 'information Index'
    end

    it 'can not access to create info page as admin user' do
      visit new_admin_information_path
      expect(page).to have_no_content 'information Index'
    end

    it 'can not access to edit info page as admin user' do
      visit edit_admin_information_path info
      expect(page).to have_no_content 'info Index'
    end
  end
end
