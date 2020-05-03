require 'rails_helper'
require 'date'

RSpec.describe 'Admin::Articles', type: :system do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user, name: 'ssss') }
  let!(:article) { create(:article) }
  let!(:article_in_draft) { create(:article, status: 'draft') }
  let!(:last_article) { create(:article, :last_article) }
  let(:date) { '2020-1-15'.to_date }

  context 'when signed in as admin' do
    before do
      admin_sign_in(admin.name, 'japanepa19')
      visit admin_articles_path
    end

    it 'show admin articles index page' do
      expect(page).to have_content article.title
    end

    it 'create article' do
      first(:link, "新規作成").click
      using_wait_time 15 do
        expect(page).to have_content "Article Form"
      end
      find('#title_input').set('new_article')
      find('#lead_input').set('article_lead')
      find('#contents_input').set('test_content')
      click_on 'submit'

      using_wait_time 10 do
        expect(page).to have_no_content 'Article Form'
        expect(page).to have_content 'new_article'
      end
    end

    it 'edit article' do
      first('.edit_btn').click
      find('#title_input').set('updated title')
      click_on 'submit'

      expect(page).to have_no_content 'Article Form'
      expect(page).to have_content 'updated title'
    end

    it 'delete article' do
      first('.edit_btn').click
      using_wait_time 10 do
        click_on '削除'
      end
      page.driver.browser.switch_to.alert.accept

      using_wait_time 10 do
        expect(page).to have_no_content 'Article Form'
        expect(page).to have_no_content last_article.title
      end
    end

    it 'delete article with ajax', js: true do
      page.first('.delete_btn').click
      page.driver.browser.switch_to.alert.accept

      using_wait_time 10 do
        expect(page).to have_no_content last_article.title
      end
    end

    describe 'search article' do
      before do
        travel_to('2020-1-8') do
          @article_7days_ago = create(:article, title: '7days_ago')
        end
        visit admin_articles_path
      end

      context 'search article by collect value' do
        it 'search article by word' do
          fill_in 'keyword_search', with: article.title
          click_on 'Search'
          expect(page).to have_no_content last_article.title
          expect(page).to have_content article.title
        end

        it 'search article by status' do
          expect(page).to have_content article_in_draft.title
          find('#public_btn').click
          click_on 'Search'
          # 公開している記事
          expect(page).to have_css '.fa-eye'
          expect(page).to have_content article.title
          # 非公開の記事
          expect(page).to have_no_css '.a-eye-slash'
          expect(page).to have_no_content article_in_draft.title
        end

        it 'search article by creation date' do
          find('.creation_date_from').set(date.prev_day(9).strftime("%Y/%m/%d"))
          find('.creation_date_to').set(date.prev_day(5).strftime("%Y/%m/%d"))
          click_button 'Search'
          expect(page).to have_no_content article.title
          expect(page).to have_content @article_7days_ago.title
        end

        it 'search article by updated date' do
          find('.update_date_from').set(date.prev_day(9).strftime("%Y/%m/%d"))
          find('.update_date_to').set(date.prev_day(5).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_content @article_7days_ago.title
          expect(page).to have_no_content article.title
        end
      end

      context 'search article by incollect value' do
        it 'search article by word' do
          fill_in 'keyword_search', with: 'wrong_keywords'
          click_on 'Search'
          expect(page).to have_content 'No articles....'
        end

        it 'search article by creation date' do
          find('.creation_date_from').set(date.prev_day(30).strftime("%Y/%m/%d"))
          find('.creation_date_to').set(date.prev_day(20).strftime("%Y/%m/%d"))
          click_button 'Search'
          expect(page).to have_content 'No articles....'
        end

        it 'search article by updated date' do
          find('.update_date_from').set(date.prev_day(30).strftime("%Y/%m/%d"))
          find('.update_date_to').set(date.prev_day(20).strftime("%Y/%m/%d"))
          click_on 'Search'
          expect(page).to have_content 'No articles....'
        end
      end
    end

    describe 'Sort article' do
      it 'sort article by id' do
        click_on 'No.'
        within '.row_0' do
          expect(page).to have_content last_article.title
        end
      end

      it 'sort article by title' do
        click_on 'Title'
        within '.row_0' do
          expect(page).to have_content last_article.title
        end
      end
      it 'sort article by view' do
        click_on 'Views'
        within '.row_0' do
          expect(page).to have_content last_article.title
        end
      end

      it 'sort article by likes' do
        click_on 'Likes'
        within '.row_0' do
          expect(page).to have_content last_article.title
        end
      end
      it 'sort article by bookmark' do
        click_on 'Bookmarks'
        within '.row_0' do
          expect(page).to have_content last_article.title
        end
      end

      it 'sort article by creation date' do
        click_on 'Creation Date'
        within '.row_0' do
          expect(page).to have_content last_article.title
        end
      end

      it 'sort article by update date' do
        click_on 'Update Date'
        within '.row_0' do
          expect(page).to have_content last_article.title
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
