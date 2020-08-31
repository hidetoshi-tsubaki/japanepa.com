require 'rails_helper'
RSpec.describe 'Quiz', type: :system do
  let!(:user) { create(:user, :with_related_model) }
  let!(:level1) { create(:quiz_category) }
  let!(:level2) { create(:quiz_category) }
  let!(:section1) { create(:section, parent_id: level1.id) }
  let!(:section2) { create(:section, parent_id: level2.id) }
  let!(:title1) { create(:title, parent_id: section1.id) }
  let!(:title2) { create(:title, parent_id: section1.id) }
  let!(:title3) { create(:title, parent_id: section2.id) }
  let!(:quiz1) { create(:quiz, category_id: title1.id) }
  let!(:quiz2_1) { create(:quiz, category_id: title1.id) }
  let!(:quiz2_2) { create(:quiz, category_id: title2.id) }
  let!(:mistake) { create(:mistake, user_id: user.id, quiz_id: quiz2_1.id, title_id: title2.id) }

  it 'All function work normally', js: true do
    user_sign_in(user.name, 'japanepa')
    visit quiz_categories_path

    # クイズのlevel一覧
    expect(page).to have_content level1.name
    expect(page).to have_content level2.name

    # クイズのsectionとtitle一覧
    find(:link, level1.name).click
    using_wait_time 20 do
      expect(page).to have_content section1.name
      expect(page).to have_content title1.name
    end

    expect(page).to have_no_content level2.name
    first(:link, "Play").click
    expect(page).to have_content title1.name
  end
end
