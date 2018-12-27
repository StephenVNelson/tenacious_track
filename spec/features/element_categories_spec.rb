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
    sleep 3
    page.driver.browser.navigate.refresh
    sleep 5
    expect(source_category.sort).to eq(1)
  end
end
