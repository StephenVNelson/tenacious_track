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
    page.driver.browser.navigate.refresh
    # sleep 3
    # expect(ElementCategory.find_by(sort: 1)).to eq(target_category)
    # expect(ElementCategory.find_by(sort: 5)).to eq(source_category)
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
end
