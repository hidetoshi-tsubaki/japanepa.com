require 'rails_helper'

RSpec.describe 'Admin::QuizCategory', type: :system do
  let!(:admin) { create(:admin) }
  let!(:level) { create(:quiz_category) }
  let!(:section) { create(:section, parent_id: level.id) }
  let!(:title) { create(:title, :with_related_model, parent_id: section.id) }

  context 'when signed in as admin' do
    before do
      admin_sign_in(admin.name, 'japanepa')
      visit admin_quiz_categories_path
    end

    it 'show quiz categories', retry: 3 do
      expect(page).to have_content level.name
      first('.edit_btn').click
      visit categories_admin_quiz_category_path level
      expect(page).to have_content section.name
      first('.edit_btn').click
      visit categories_admin_quiz_category_path section
      expect(page).to have_content title.name
    end

    it 'create quiz level', js: true do
      find('.admin_create_btn').click
      expect(page).to have_content 'Category Form'
      find('#form_input').set('new-level')
      click_on '作成'
      visit admin_quiz_categories_path
      expect(page).to have_content 'new-level'
    end

    it 'create quiz section', retry: 3 do
      find('.edit_btn').click
      visit categories_admin_quiz_category_path level
      find('.admin_create_btn').click
      expect(page).to have_content 'Category Form'
      find('#form_input').set('new-section')
      click_on '作成'
      visit categories_admin_quiz_category_path level
      expect(page).to have_content 'new-section'
    end

    it 'create quiz title' do
      visit categories_admin_quiz_category_path section
      find('.admin_create_btn').click
      expect(page).to have_content 'Category Form'
      find('#form_input').set('new-title')
      click_on '作成'
      visit categories_admin_quiz_category_path section
      expect(page).to have_content 'new-title'
    end

    it 'edit quiz level', js: true do
      visit categories_admin_quiz_category_path level
      find('#category_edit_btn').click
      expect(page).to have_content 'Category Form'
      find('#form_input').set('updated-level')
      within '.form_wrapper' do
        click_on '編集'
      end
      visit categories_admin_quiz_category_path level
      expect(page).to have_content 'updated-level'
    end

    it 'edit quiz section', js: true do
      visit categories_admin_quiz_category_path section
      find('#category_edit_btn').click
      expect(page).to have_content 'Category Form'
      find('#form_input').set('updated-section')
      within '.form_wrapper' do
        click_on '編集'
      end
      visit categories_admin_quiz_category_path section
      expect(page).to have_content 'updated-section'
    end

    it 'edit quiz title', js: true do
      visit categories_admin_quiz_category_path title
      find('#category_edit_btn').click
      expect(page).to have_content 'Category Form'
      find('#form_input').set('updated-title')
      within '.form_wrapper' do
        click_on '編集'
      end
      visit categories_admin_quiz_category_path title
      expect(page).to have_content 'updated-title'
    end

    it 'delete quiz level', js: true do
      first('.delete_btn').click
      page.driver.browser.switch_to.alert.accept
      visit admin_quiz_categories_path
      expect(page).to have_no_content level.name
    end

    it 'delete quiz section', js: true do
      visit categories_admin_quiz_category_path level
      first('.delete_btn').click
      page.driver.browser.switch_to.alert.accept
      visit categories_admin_quiz_category_path level
      expect(page).to have_no_content section.name
    end

    it 'delete quiz title', js: true do
      visit categories_admin_quiz_category_path section
      first('.delete_btn').click
      page.driver.browser.switch_to.alert.accept
      visit categories_admin_quiz_category_path section
      expect(page).to have_no_content title.name
    end
  end

  context 'when does not sigend in as admin' do
    it 'can not access to admin quiz category index' do
      visit admin_quiz_categories_path
      expect(page).to have_no_content 'カテゴリー'
    end

    it 'can not access to admin quiz levels as admin user' do
      visit admin_quiz_category_path level
      expect(page).to have_no_content level.name
    end

    it 'can not access to admin quiz sections as admin user' do
      visit admin_quiz_category_path section
      expect(page).to have_no_content section.name
    end

    it 'can not delete quiz titles as admin user' do
      visit admin_quiz_category_path title
      expect(page).to have_no_content title.name
    end
  end
end
