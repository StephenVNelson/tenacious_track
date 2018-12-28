require 'rails_helper'

RSpec.feature "ElementCategories", type: :feature do
  scenario "creates, reorders, deletes categories", js: true do
    5.times do
      FactoryBot.create(:element_category)
    end
    target_category = ElementCategory.first
    source_category = ElementCategory.last
    user = FactoryBot.create(:admin)
    login user
    visit '/element_categories'
    source = page.find("##{source_category.sortable_id}").find('i.fas.fa-grip-vertical')
    target = page.find("##{target_category.sortable_id}").find('i.fas.fa-grip-vertical')
    source.drag_to(target)
    page.driver.browser.navigate.refresh
    expect(ElementCategory.find_by(sort: 0)).to eq(source_category)
    click_link source_category.category_name.to_s
    fill_in "element_category_category_name", with: "New Guy"
    click_button "Update \"#{source_category.category_name}\""
    expect(page).to have_current_path("/element_categories")
    expect(page).to have_text("New Guy")
    expect{
      click_link "New Guy"
      click_button "Delete \"New Guy\""
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_current_path("/element_categories")
    }.to change(ElementCategory, :count).by(-1)
  end

  scenario "limited access for trainers and those who aren't logged in" do
    user = FactoryBot.create(:user)
    login user
    visit '/element_categories'
    expect(page).to have_current_path("/users/#{user.id}")
    click_link("Account")
    click_link("Log out")
    expect(page).to have_current_path("/")
    visit '/element_categories'
    expect(page).to have_current_path(login_path)
    expect(page).to have_text("Please log in.")
  end
end
