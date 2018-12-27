require 'rails_helper'
RSpec.feature "Elements", type: :feature do

  scenario "creates and deletes a new element", js: true do
    FactoryBot.create(:body_position)
    user = FactoryBot.create(:admin)

    visit root_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    expect {
      click_button "Exercise"
      click_link "Elements"
      expect(page).to have_current_path("/elements")
      find('#add-element', :text => 'Add Element').click
      select "Body Position", from: "element_element_category_id"
      fill_in "element_name", with: "New Element"
      click_button "Create Element"
      expect(page).to have_text("New Element")
    }.to change(Element.all, :count).by(1)

    expect {
      find('.fa-trash-alt').click
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_text("Element deleted")
    }.to change(Element.all, :count).by(-1)
  end

  scenario "edits an existing element" do
    FactoryBot.create(:element_category, category_name: "Wamo!")
    element = FactoryBot.create(:element)
    user = FactoryBot.create(:admin)
    login user
    visit '/elements'
    find(:css, 'a.edit-icon').click
    expect(page).to have_current_path("/elements/#{element.id}/edit")
    select "Wamo!", from: "element_element_category_id"
    fill_in "element_name", with: "Snorkeling"
    click_button "Update"
    expect(page).to have_current_path("/elements")
    expect(page).to have_text("Wamo!")
    expect(page).to have_text("Snorkeling")
  end

  scenario "filtering results" do
    8.times do
      FactoryBot.create(:element)
      FactoryBot.create(:element_angle)
    end
    user = FactoryBot.create(:admin)
    login user
    visit '/elements'
    page.assert_selector('ul.pagination', count: 2)
    fill_in "query", with: "Angle"
    click_button "Filter"
    page.assert_selector('ul.pagination', count: 0)
    expect(page).to have_text("Angle")
    expect(page).not_to have_text("Body Position")
    fill_in "query", with: "element_1"
    click_button "Filter"
    expect(page).to have_text("element_1")
    expect(page).not_to have_text("element_2")
    fill_in "query", with: ""
    click_button "Filter"
    page.assert_selector('a.edit-icon', count: 15)
    first("li.page-item", text: "2").click_link
    page.assert_selector('a.edit-icon', count: 1)
  end

  scenario "non admins cannot see edit and delete" do
    FactoryBot.create(:element)
    user = FactoryBot.create(:user)
    login user
    visit '/elements'
    page.assert_selector('a.edit-icon', count: 0)
    page.assert_selector('a.trash-icon', count: 0)
  end
end
