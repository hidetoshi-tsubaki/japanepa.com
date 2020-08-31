require 'rails_helper'
require 'date'

RSpec.describe 'Admin::Talks', type: :system do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:last_user) { create(:user, name: 'www user') }
  let!(:community) { create(:community, founder_id: user.id) }
  let!(:last_community) { create(:community, name: 'www community', founder_id: user.id) }
  let!(:talk) { create(:talk, user_id: user.id) }
  let!(:most_liked_talk) { create(:talk, content: 'most likes talk') }
  let!(:like_talk) { create(:like_talk, talk_id: most_liked_talk.id) }
  let!(:last_talk) { create(:talk, content: 'wwwlast', user_id: last_user.id) }

  context 'when signed in as admin' do
    before do
      admin_sign_in(admin.name, 'japanepa')
      visit admin_talks_path
    end

    it 'show admin talks index' do
      expect(page).to have_content talk.content
      expect(page).to have_content last_talk.content
    end

    it 'show talk detail' do
      visit admin_talk_path(talk)
      expect(page).to have_content talk.content
      expect(page).to have_no_content last_talk.content
    end

    it 'delete talk' do
      first('.edit_btn').click
      expect(page).to have_content last_talk.content
      find(".delete_btn").click
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_no_content last_talk.content
    end

    it 'delete talk with ajax', js: true do
      first('.delete_btn').click
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_no_content last_talk.content
    end

    describe 'Search talk' do
      before do
        travel_to(Date.today.prev_day(7)) do
          @talk_7days_old = create(:talk, user_id: user.id, content: '7days_old')
        end
      end

      context 'search talk by collect values' do
        it 'search talk by word' do
          expect(page).to have_content talk.content
          find('.keyword_search').set(last_talk.content)
          click_on 'Search'
          expect(page).to have_content last_talk.content
          expect(page).to have_no_content talk.content
        end

        it 'search talk by registration date' do
          find('#creation_date_from').set(Date.today.prev_day(9).strftime("%Y/%m/%d"))
          find('#creation_date_to').set(Date.today.prev_day(4).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_no_content talk.content
          expect(page).to have_content @talk_7days_old.content
        end
      end

      context 'Search talk by incollect values' do
        it 'search talk by word' do
          find('.keyword_search').set('wrong keyword')
          click_on 'Search'
          expect(page).to have_content 'No talks....'
          expect(page).to have_no_content talk.content
        end

        it 'search take by registration date' do
          find('#creation_date_from').set(Date.today.prev_day(30).strftime("%Y/%m/%d"))
          find('#creation_date_to').set(Date.today.prev_day(25).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_content 'No talks....'
          expect(page).to have_no_content talk.content
        end
      end
    end

    describe 'Sort talk' do
      it 'sort talk by id' do
        click_on 'No.'
        within '.row_0' do
          expect(page).to have_content last_talk.id
        end
      end

      it 'sort talk by community name' do
        within ".index_head" do
          click_on 'Community'
        end
        within '.row_0' do
          expect(page).to have_content last_talk.community.name
        end
      end

      it 'sort talk by user name', retry: 5 do
        click_on 'User'
        using_wait_time 25 do
          within '.row_0' do
            expect(page).to have_content last_talk.user.name
          end
        end
      end

      it 'sort talk by like count', retry: 3 do
        click_on 'Likes'
        within '.row_0' do
          expect(page).to have_content most_liked_talk.content
        end
      end

      it 'sort talk by creation date' do
        click_on 'Creation Date'
        within '.row_0' do
          expect(page).to have_content last_talk.content
        end
      end
    end
  end

  context 'when does not signed in as admin' do
    it 'can not access to admin talks index page' do
      visit admin_talks_path
      expect(page).to have_no_content talk.content
    end
  end
end
