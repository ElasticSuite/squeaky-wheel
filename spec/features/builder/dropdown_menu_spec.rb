require "spec_helper"

describe "Within the top bar of builder", :sauce => ENV['ON_SAUCE'] do
  def visit_menu
    first("span", :text => "Menu").click
  end

  it "has the top links", :js => true do
    sign_in_rep
    create_order

    page.should have_content "Browse"
    page.should have_content "Order"
    page.should have_content "Sizing"
    page.should have_content "Purchase"
    page.should have_content "Summary"
    page.should have_content "Items"
    page.should have_content "Menu"

    destroy_order
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
    visit_menu
    destroy_order
  end

  it "menu > new order works", :js => true do
    sign_in_rep
    create_order
    visit_menu

    find("td", :text => "New Order").click
    current_url.split("#")[1] == "dashboard,newDocument"

    page.should have_content "New Order"
    find_field("Name")
    find("table#elasticScramble_dashboard_newDocument_catalog")
    find("input#elasticScramble_dashboard_newDocument_start_date")
    within("div.submit") do
      find("span.dijitReset.dijitInline.dijitButtonNode", :text => "Create")
    end
    within('div[id^="dgrid_0-row"]', :match => :first) do
      within("span.dijitReset.close") do
        find("span.dijitButtonContents.dijitStretch").click
      end
    end
    within("div.modalConfirm") do
      find("span.dijitReset.dijitInline.dijitButtonText", :text => "Yes").click
    end
    page.should have_content("Document removed.")
  end

  it "menu > save as works", :js => true do
    sign_in_rep
    create_order
    visit_menu

    find("td", :text => "Save As").click
    within("div.dijitDialog.modalPrompt.modalPromptFocused") do
      page.should have_content "Enter a name for the new order"
      page.should have_content "SAVE AS"
      within(:css, "div.dijitReset.dijitInputField.dijitInputContainer") do
        find("input").set("Better Test Name")
      end
    end
    find("span.dijitReset.dijitButtonText", :text => "Okay").click

    page.should have_content("Document saved as \"Better Test Name\"")
    visit_menu
    find("td", :text => "Close").click
    find("span.dijitReset.dijitInline.dijitButtonNode", :text => "Open From Cloud").click

    page.should have_content("Better Test Name")
    destroy_order
  end

  # it "menu > download to desktop works", :js => true do
  #   pending
  #   visit_menu
  # end
end

