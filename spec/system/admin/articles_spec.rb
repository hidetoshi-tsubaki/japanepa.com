require 'rails_helper'

RSpec.describe 'Admin::Articles', type: :system do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:article) { create(:article) }
  let!(:article_in_draft) { create(:article, status: 'draft') }
  let!(:last_article) { create(:article, :last) }

  context 'when signed in as admin' do
    before do
      admin_sign_in(admin.name, 'japanepa')
      visit admin_articles_path
    end

    it 'work correctly', js: true, retry: 2 do
      # 一覧表示
      expect(page).to have_content "記事一覧"
      expect(page).to have_content article.title

      # 新規作成
      visit new_admin_article_path
      find('#title_input').set('new_article')
      find('#lead_input').set('article_lead')
      find('#contents_input').set('test_content')
      find('.upload_btn').click
      attach_file "article[img]", "#{Rails.root}/spec/factories/images/img.png", make_visible: true
      click_on '新規作成'
      using_wait_time 10 do
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'new_article'
      end

      # 編集
      visit edit_admin_article_path article
      find('#title_input').set('updated title')
      click_on '編集'
      using_wait_time 10 do
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'updated title'
      end

      # 削除
      visit edit_admin_article_path last_article
      expect(page).to have_content last_article.title
      find('.delete_btn').click
      page.driver.browser.switch_to.alert.accept
      visit admin_articles_path
      expect(page).to have_no_content last_article.title

      # ajaxで削除
      expect(page).to have_content "new_article"
      page.first('.delete_btn').click
      page.driver.browser.switch_to.alert.accept
      visit admin_articles_path
      expect(page).to have_no_content "new_article"
    end

    describe 'search article' do
      before do
        travel_to(Date.today.prev_day(7)) do
          @article_7days_ago = create(:article, title: '7days_ago')
        end
        visit admin_articles_path
      end

      context 'search article by collect value' do
        it 'search article by word' do
          find('.keyword_search').set(article.title)
          click_on 'Search'
          expect(page).to have_content article.title
          expect(page).to have_no_content last_article.title
        end

        it 'search article by status' do
          expect(page).to have_content article_in_draft.title
          find('#public_btn').click
          click_on 'Search'
          expect(page).to have_content article.title
          expect(page).to have_no_css '.a-eye-slash'
          expect(page).to have_no_content article_in_draft.title
        end

        it 'search article by creation date' do
          find('#creation_date_from').set(Date.today.prev_day(9).strftime("%Y/%m/%d"))
          find('#creation_date_to').set(Date.today.prev_day(5).strftime("%Y/%m/%d"))
          click_button 'Search'
          expect(page).to have_no_content article.title
          expect(page).to have_content @article_7days_ago.title
        end

        it 'search article by updated date' do
          find('#update_date_from').set(Date.today.prev_day(9).strftime("%Y/%m/%d"))
          find('#update_date_to').set(Date.today.prev_day(5).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_content @article_7days_ago.title
          expect(page).to have_no_content article.title
        end
      end

      context 'search article by incorrect value' do
        it 'search article by word' do
          find('.keyword_search').set('wrong_keywords')
          click_on 'Search'
          expect(page).to have_content 'No articles....'
          expect(page).to have_no_content article.title
        end

        it 'search article by creation date' do
          find('#creation_date_from').set(Date.today.prev_day(30).strftime("%Y/%m/%d"))
          find('#creation_date_to').set(Date.today.prev_day(20).strftime("%Y/%m/%d"))
          click_button 'Search'
          expect(page).to have_content 'No articles....'
          expect(page).to have_no_content article.title
        end

        it 'search article by updated date' do
          find('#update_date_from').set(Date.today.prev_day(30).strftime("%Y/%m/%d"))
          find('#update_date_to').set(Date.today.prev_day(20).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_content 'No articles....'
          expect(page).to have_no_content article.title
        end
      end
    end

    describe 'Sort article' do
      before do
        travel_to(Date.tomorrow) do
          @latest_article = create(:article, title: 'latest')
        end
      end

      it 'can sort article by id' do
        click_on 'No.'
        within '.row_0' do
          expect(page).to have_content @latest_article.title
        end
      end

      it 'can sort article by title' do
        click_on 'Title'
        within '.row_0' do
          expect(page).to have_content last_article.title
        end
      end

      it 'can sort article by view' do
        click_on 'Views'
        within '.row_0' do
          expect(page).to have_content last_article.title
        end
      end

      it 'can sort article by likes' do
        click_on 'Likes'
        within '.row_0' do
          expect(page).to have_content last_article.title
        end
      end

      it 'can sort article by bookmark' do
        click_on 'Bookmarks'
        within '.row_0' do
          expect(page).to have_content last_article.title
        end
      end

      it 'can sort article by creation date' do
        click_on 'Creation Date'
        within '.row_0' do
          expect(page).to have_content @latest_article.title
        end
      end

      it 'can sort article by update date' do
        click_on 'Update Date'
        within '.row_0' do
          expect(page).to have_content @latest_article.title
        end
      end
    end
  end

  context 'when does not sigend in as admin' do
    it 'can not access to admin quizzes index' do
      visit admin_articles_path
      expect(page).to have_no_content 'Artcile Index'
    end

    it 'can not access to new article page as admin user' do
      visit new_admin_article_path
      expect(page).to have_no_content 'Article Form'
    end

    it 'can not access to edit article page as admin user' do
      visit edit_admin_article_path(article)
      expect(page).to have_no_content 'Article Form'
    end
  end
end
