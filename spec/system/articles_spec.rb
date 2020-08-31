require 'rails_helper'

RSpec.describe 'Articles', type: :system do
  let!(:user) { create(:user, :with_related_model) }
  let!(:article) { create(:article) }
  let!(:article2) { create(:article) }

  before do
    create_list(:level, 10)
  end

  it 'All function work normally', retry: 5 do
    user_sign_in(user.name, 'japanepa')
    visit articles_path
    # 一覧表示
    expect(page).to have_content 'Articles index'
    expect(page).to have_content article.title
    expect(page).to have_content article2.title

    # 詳細表示
    find('.article_1').click
    using_wait_time 25 do
      within '.article_contents' do
        expect(page).to have_content "How to study Japanese1"
      end
    end

    # ブックマークをつける/外す
    within '.article_contents' do
      find("#bookmark_btn_#{article.id}").click
      within '.bookmark_btn' do
        expect(page).to have_content '1'
      end

      find("#bookmark_btn_#{article.id}").click
      within '.bookmark_btn' do
        expect(page).to have_content '0'
      end
    end

    # 「いいね」をつける/外す
    within '.article_contents' do
      find("#like_btn_#{article.id}").click
      within '.like_btn' do
        expect(page).to have_content '1'
      end

      find("#like_btn_#{article.id}").click
      within '.like_btn' do
        expect(page).to have_content '0'
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
