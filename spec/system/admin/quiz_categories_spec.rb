require 'rails_helper'

RSpec.describe 'Admin::QuizCategory', type: :system do
  let!(:admin) { create(:admin) }
  let!(:level) { create(:quiz_category, :level) }
  let!(:section) { create(:quiz_category, :section, parent_id: level.id) }
  let!(:title) { create(:quiz_category, :title, parent_id: section.id) }

  context 'when signed in as admin' do
    before do
      admin_sign_in(admin.name, 'japanepa19')
      visit admin_quiz_categories_path
    end

    it 'show quiz categories' do
      expect(page).to have_content level.name
      first('.edit_btn').click
      expect(page).to have_content section.name
      first('.edit_btn').click
      expect(page).to have_content title.name
    end

    it 'create quiz level', js: true do
      find('.new_btn').click
      using_wait_time 10 do
        expect(page).to have_content 'Category Form'
      end
      find('#form_input').set('new-level')
      click_on '作成'

      expect(page).to have_content 'new-level'
    end

    it 'create quiz category' do
      visit admin_quiz_category_path level
      find('.new_btn').click
      expect(page).to have_content 'Category Form'
      find('#form_input').set('new-section')
      click_on '作成'
      expect(page).to have_content 'new-section'
    end

    it 'create quiz title' do
      visit admin_quiz_category_path section
      find('.new_btn').click
      expect(page).to have_content 'Category Form'
      find('#form_input').set('new-title')
      click_on '作成'
      
      using_wait_time 10 do
        expect(page).to have_content 'new-title'
      end
    end

    it 'edit quiz level', js: true do
      visit admin_quiz_category_path level
      find('#category_edit_btn').click
      expect(page).to have_content 'Category Form'
      find('#form_input').set('updated-category-parent')
      within '.form_wrapper' do
        click_on '編集'
      end
      expect(page).to have_content 'updated-category-parent'
    end

    it 'edit quiz section', js: true do
      visit admin_quiz_category_path section
      find('#category_edit_btn').click
      expect(page).to have_content 'Category Form'
      find('#form_input').set('updated-category-child')
      within '.form_wrapper' do
        click_on '編集'
      end
      expect(page).to have_content 'updated-category-child'
    end

    it 'edit quiz title', js: true do
      visit admin_quiz_category_path title
      find('#category_edit_btn').click
      expect(page).to have_content 'Category Form'
      find('#form_input').set('updated-category-grandchild')
      within '.form_wrapper' do
        click_on '編集'
      end
      expect(page).to have_content 'updated-category-grandchild'
    end

    it 'delete quiz level', js: true do
      first('.delete_btn').click
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_no_content level.name
    end

    it 'delete quiz section', js: true do
      visit admin_quiz_category_path level
      first('.delete_btn').click
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_no_content section.name
    end

    it 'delete quiz title', js: true do
      visit admin_quiz_category_path section
      first('.delete_btn').click
      page.driver.browser.switch_to.alert.accept
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
