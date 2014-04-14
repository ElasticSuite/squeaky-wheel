require "spec_helper"

describe "Within the top bar of builder" do
  def visit_menu
    visit_builder
    first("span", :text => "Menu").click
  end

  it "has the top links", :js => true do
    sign_in_rep
    create_order
    visit_builder

    page.should have_content "Browse"
    page.should have_content "Order"
    page.should have_content "Sizing"
    page.should have_content "Purchase"
    page.should have_content "Summary"
    page.should have_content "Items"
    page.should have_content "Menu"

    destroy_order
    sign_out
  end

  it "has the menu links", :js => true do
    sign_in_rep
    create_order
    visit_menu

    page.should have_content "New Order"
    page.should have_content "Save As"
    page.should have_content "Download To Desktop"
    page.should have_content "Import CSV"
    page.should have_content "Open From Cloud"
    page.should have_content "Open From Desktop"
    page.should have_content "Print Jobs"
    page.should have_content "Manage Catalogs"
    page.should have_content "Rename Order"
    page.should have_content "Account Settings"
    page.should have_content "Full Screen Mode"
    page.should have_content "Preferences"
    page.should have_content "Support"
    page.should have_content "Close"

    destroy_order
    sign_out
  end

  it "menu > new order works", :js => true do
    sign_in_rep
    create_order
    visit_menu

    find("td", :text => "New Order").click
    current_url.split("#")[1] == "dashboard,newDocument"

    page.should have_content "New Order"
    find_field("Name")
    find("input#customerField")
    find("table#elasticScramble_dashboard_newDocument_catalog")
    find("table#elasticScramble_dashboard_newDocument_custom_catalog")
    find("input#elasticScramble_dashboard_newDocument_start_date")
    find("#dijit_form_Button_33_label", :text => "Create")

    destroy_order
    sign_out
  end

  it "menu > save as works", :js => true do
    sign_in_rep
    create_order
    visit_menu

    find("td", :text => "Save As").click
    within(:css, "div.dijitDialog.modalPrompt.modalPromptFocused") do
      page.should have_content "Enter a name for the new order"
      page.should have_content "SAVE AS"
      page.save_screenshot("save_as_modal.png")
      within(:css, "div.dijitReset.dijitInputField.dijitInputContainer") do
        find("input").set("Better Test Name")
      end
      find(:css, "span.dijitInline.dijitButtonText", :text => "Save").click
    end

    page.should have_content("Document saved as \"Better Test Name\"")
    dojo_visit('dashboard,openFromCloud')
    page.should have_content("Better Test Name")
    destroy_order
    sign_out
  end

  it "menu > download to desktop works", :js => true do
    pending
    visit_menu
  end
end

