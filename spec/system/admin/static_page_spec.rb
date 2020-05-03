require 'rails_helper'

RSpec.describe 'Admin::StaticPage', type: :system do
  let!(:admin) { create(:admin) }

  context 'when signed in as admin' do
    before do
      admin_sign_in(admin.name, 'japanepa19')
      visit admin_articles_path
    end

    it 'show static page' do
      expect(page).to have_css '.fa-user-cog'
    end
  end

  context 'when does not signed in as admin' do
    it 'can not access to static page' do
      expect(page).to have_no_css '.fa-user-cog'
    end
  end
end
