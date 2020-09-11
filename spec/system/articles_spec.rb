require 'rails_helper'

RSpec.describe 'Articles', type: :system do
  let!(:user) { create(:user, :with_related_model) }
  let!(:article) { create(:article) }
  let!(:article2) { create(:article, contents: "article contents") }

  it 'All function work normally', js: true, retry: 2 do
    user_sign_in(user.name, 'japanepa')
    visit articles_path

    # 一覧表示
    expect(page).to have_content 'Articles index'
    expect(page).to have_content article.title
    expect(page).to have_content article2.title

    # # 詳細表示
    find(".article_link_#{article2.id}").click
    expect(page).to have_content 'article contents'

    # ブックマークをつける/外す
    within '.article_wrapper' do
      within "#bookmark_btn_#{article2.id}" do
        find(:link, "0").click
        within '.bookmark_btn' do
          expect(page).to have_content '1'
        end
        find(:link, "1").click
        within '.bookmark_btn' do
          expect(page).to have_content '0'
        end
      end
    end

    # 「いいね」をつける/外す
    within '.article_wrapper' do
      within "#like_btn_#{article2.id}" do
        find(:link, "0").click
        within '.like_btn' do
          expect(page).to have_content '1'
        end
        find(:link, "1").click
        within '.like_btn' do
          expect(page).to have_content '0'
        end
      end
    end

    # 記事を検索
    find('.search_input').set(article.title)
    find('.search_btn').click
    within '.main_section' do
      expect(page).to have_content article.lead
      expect(page).to have_no_content article2.lead
    end
    find('.search_input').set('wrong-keyword')
    find('.search_btn').click
    expect(page).to have_content 'No article...'
  end
end
