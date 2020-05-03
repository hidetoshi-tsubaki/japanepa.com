require 'rails_helper'

RSpec.describe 'Articles', type: :system do
  let!(:user) { create(:user) }
  let!(:article) { create(:article) }
  let!(:article2) { create(:article) }

  before do
    user_sign_in(user.name, 'password')
    visit articles_path
  end

  it 'All function work normally' do
    # 一覧表示
    expect(page).to have_content 'Articles index'
    expect(page).to have_content article.title
    expect(page).to have_content article2.title

    # 詳細表示
    find('#article_1').click
    expect(page).to have_content 'article-contents1'

    # ブックマーク
    expect(Bookmark.count).to eq 0
    within '.article_contents_wrapper' do
      find('.fa-star').click
      within '.bookmark_btn' do
        expect(page).to have_content '1'
        expect(page).to have_css '.fas'
      end
    end
    expect(Bookmark.count).to eq 1

    # 「いいね」をつける/外す
    expect(LikeArticle.count).to eq 0
    within '.article_contents_wrapper' do
      find('.fa-heart').click
      within '.like_btn' do
        expect(page).to have_content '1'
        expect(page).to have_css '.fas'
      end
    end
    expect(LikeArticle.count).to eq 1
    expect(page).to have_css '.fas'

    # 記事を検索
    find('.search_input').set(article.title)
    find('#search_btn').click
    expect(page).to have_content article.lead
    expect(page).to have_no_content article2.lead
    find('.search_input').set('wrong-keyword')
    find('#search_btn').click
    expect(page).to have_content 'No article...'
  end
end
