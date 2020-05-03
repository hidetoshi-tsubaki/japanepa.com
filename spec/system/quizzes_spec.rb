require 'rails_helper'
RSpec.describe 'Quiz', type: :system do
  let!(:user) { create(:user) }
  let!(:level1) { create(:quiz_category, :level) }
  let!(:level2) { create(:quiz_category, :level) }
  let!(:section1) { create(:quiz_category, :section, parent_id: level1.id) }
  let!(:section2) { create(:quiz_category, :section, parent_id: level2.id) }
  let!(:title1) { create(:quiz_category, :title, parent_id: section1.id) }
  let!(:title2) { create(:quiz_category, :title, parent_id: section1.id) }
  let!(:title3) { create(:quiz_category, :title, parent_id: section2.id) }
  let!(:quiz1) { create(:quiz, category_id: title1.id) }
  let!(:quiz2_1) { create(:quiz, category_id: title1.id) }
  let!(:quiz2_2) { create(:quiz, category_id: title2.id) }
  let!(:mistake) { create(:mistake, user_id: user.id, quiz_id: quiz2_1.id, title_id: title2.id) }

  before do
    create_list(:level, 10)
    user_sign_in(user.name, 'password')
    visit quizzes_path
  end

  it 'All function work normally', js: true do
    # クイズカテゴリーの一覧表示
    using_wait_time 20 do
      expect(page).to have_content level1.name
    end
    expect(page).to have_content level2.name
    find(".section_#{section1.id}").click
    expect(page).to have_content title1.name
  end
end
