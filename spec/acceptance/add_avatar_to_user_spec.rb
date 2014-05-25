require_relative '../acceptance_helper'

feature 'User adds an avatar to his profile',
%{
  In order to show my photo to other users
  As a user
  I want to add avatar to my profile
  } do

  given(:user) { create(:user) }

  background do
    sign_in_with(user.email, user.password)
    visit user_path(user)
  end

  context 'with valid image' do
    scenario 'upload avatar' do
      click_on 'Редактировать'

      attach_file "Аватар", File.join(
        Rails.root, "spec", "fixtures", "logo.png")
      click_on 'Сохранить'

      expect(page.find('.avatar')['src']).to eq("/uploads/user/avatar/#{user.profile.id}/medium_logo.png")
    end
  end

  context 'with invalid image' do
    scenario 'upload avatar' do
      click_on 'Редактировать'

      attach_file "Аватар", File.join(
        Rails.root, "spec", "spec_helper.rb")
      click_on 'Сохранить'

      expect(page).to have_content("Вы не можете загружать файлы типа")
      expect(page.find('.avatar')['src']).
        to_not eq("/uploads/user/avatar/#{user.profile.id}/medium_logo.png")
    end
  end
end
