require 'rails_helper'

RSpec.describe 'Admin::Quizzes', type: :system do
  let!(:admin) { create(:admin) }
  let!(:level1) { create(:quiz_category) }
  let!(:level2) { create(:quiz_category) }
  let!(:section1) { create(:section, parent_id: level1.id) }
  let!(:section2) { create(:section, parent_id: level2.id) }
  let!(:title1_1) { create(:title, :with_related_model, parent_id: section1.id) }
  let!(:title1_2) { create(:title, :with_related_model, parent_id: section1.id) }
  let!(:title2_1) { create(:title, :with_related_model, parent_id: section2.id) }
  let!(:title2_2) { create(:title, :with_related_model, parent_id: section2.id) }
  let!(:quiz1_1) { create(:quiz, category_id: title1_1.id) }
  let!(:quiz1_2) { create(:quiz, category_id: title1_2.id) }
  let!(:quiz2_1) { create(:quiz, category_id: title2_1.id) }
  let!(:quiz2_2) { create(:quiz, category_id: title2_2.id) }
  let!(:last_quiz) { create(:quiz, :last, category_id: title2_2.id) }

  context 'when signed in as admin' do
    before do
      admin_sign_in(admin.name, 'japanepa')
      visit admin_quizzes_path
    end

    it 'show admin quizes index' do
      expect(page).to have_content quiz1_1.question
      expect(page).to have_content quiz2_2.question
    end

    it 'edit quiz' do
      first('.edit_btn').click
      expect(page).to have_content 'Edit Quiz'

      find('.question_input').set('edit-question')
      click_on '編集'
      page.driver.browser.switch_to.alert.accept

      within '.row_0' do
        expect(page).to have_content 'edit-question'
      end
    end

    it 'delete quiz' do
      first('.edit_btn').click
      expect(page).to have_content 'Edit Quiz'
      find('.delete_btn').click
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_no_content last_quiz.question
    end

    it 'delete quiz with ajax', js: true do
      expect(page).to have_content last_quiz.question

      first('.delete_btn').click
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_no_content last_quiz.question
    end

    describe 'search quiz' do
      before do
        travel_to(Date.today.prev_day(7)) do
          @quiz_7days_old = create(:quiz, category_id: title1_1.id)
        end
      end

      context 'search quiz by collect values' do
        it 'search quiz by word' do
          expect(page).to have_content quiz2_1.question
          find('.keyword_search').set(quiz1_1.question)
          click_on 'Search'

          expect(page).to have_content quiz1_1.question
          expect(page).to have_no_content quiz2_1.question
        end

        it 'search quiz by creation date' do
          find('#creation_date_from').set(Date.today.prev_day(9).strftime("%Y/%m/%d"))
          find('#creation_date_to').set(Date.today.prev_day(6).strftime("%Y/%m/%d"))
          click_on 'Search'

          expect(page).to have_no_content quiz1_1.question
          expect(page).to have_content @quiz_7days_old.question
        end

        it 'search quiz by updated date' do
          find('#update_date_from').set(Date.today.prev_day(9).strftime("%Y/%m/%d"))
          find('#update_date_to').set(Date.today.prev_day(6).strftime("%Y/%m/%d"))
          click_on 'Search'

          expect(page).to have_no_content quiz1_1.question
          expect(page).to have_content @quiz_7days_old.question
        end
      end

      context 'search quiz by incollect values' do
        it 'search quiz by wrong keyword' do
          find('.keyword_search').set("wrong word")
          click_on 'Search'

          expect(page).to have_content 'No quizzes....'
        end

        it 'search quiz by wrong creation date' do
          find('#creation_date_from').set(Date.today.prev_day(30).strftime("%Y/%m/%d"))
          find('#creation_date_to').set(Date.today.prev_day(20).strftime("%Y/%m/%d"))
          click_on 'Search'

          expect(page).to have_no_content quiz1_1.question
          expect(page).to have_content 'No quizzes....'
        end

        it 'search quiz by wrong update date', retry: 3 do
          find('#update_date_from').set(Date.today.prev_day(30).strftime("%Y/%m/%d"))
          find('#update_date_to').set(Date.today.prev_day(20).strftime("%Y/%m/%d"))
          click_on 'Search'

          expect(page).to have_no_content quiz1_1.question
          expect(page).to have_content 'No quizzes....'
        end
      end
    end

    describe 'sort quiz' do
      it 'sort quiz by id' do
        click_on 'No.'
        within '.row_0' do
          expect(page).to have_content last_quiz.question
        end
      end

      it 'sort quiz by question' do
        click_on 'Question'
        within '.row_0' do
          expect(page).to have_content last_quiz.question
        end
      end

      it 'sort quiz by Answer' do
        click_on 'Answer'
        within '.row_0' do
          expect(page).to have_content last_quiz.question
        end
      end

      it 'sort quiz by Choice2' do
        click_on 'C2'
        within '.row_0' do
          expect(page).to have_content last_quiz.question
        end
      end

      it 'sort quiz by Choice3' do
        click_on 'C3'
        within '.row_0' do
          expect(page).to have_content last_quiz.question
        end
      end

      it 'sort quiz by Choice4' do
        click_on 'C4'
        within '.row_0' do
          expect(page).to have_content last_quiz.question
        end
      end
    end
  end

  context 'when does not signed in as admin user' do
    it 'can not access to admin quizzes index as admin user' do
      visit admin_quizzes_path
      expect(page).to have_no_content 'Quizzes index'
    end

    it 'can not access to create quiz page as admin user' do
      visit new_admin_quiz_path
      expect(page).to have_no_content 'Quiz Form'
    end

    it 'can not access to edit quiz page as admin user' do
      visit edit_admin_quiz_path(quiz1_1)
      expect(page).to have_no_content 'Quiz Form'
    end
  end
end
