require "spec_helper"

describe "Within create new document tab", :sauce => ENV['ON_SAUCE'] do
  it "has the proper new order options", :js => true do
    sign_in_rep(:username => "automatictester.rep")
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Create New Document").click

    page.should have_content("New Order")
    find_field("Name")
    find("input#customerField")
    find("table#elasticScramble_dashboard_newDocument_catalog")
    find("table#elasticScramble_dashboard_newDocument_custom_catalog")
    find("input#elasticScramble_dashboard_newDocument_start_date")
    within("div.submit") do
      find("span.dijitReset.dijitInline.dijitButtonNode", :text => "Create")
    end
    page.should have_content("Logout")
  end

  it "will transition into builder on create", :js => true do
    sign_in_rep(:username => "automatictester.rep")
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Create New Document").click

    find_field("Name").set("Testing Order A")
    within("div.submit") do
      find("span.dijitReset.dijitInline.dijitButtonNode", :text => "Create").click
    end

    sleep(0.2)
    page.should have_content("0.00 Total")
    current_url.split("#")[1] == "builder,browse"
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Menu").click
    first("td", :text => "Save").click
    page.should have_content("Document saved.")
    destroy_order
  end

  it "wont create if the catalog name is invalid", :js => true  do
    sign_in_rep(:username => "automatictester.rep")
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Create New Document").click

    find_field("Name").set(" ")
    within("div.submit") do
      find("span.dijitReset.dijitInline.dijitButtonNode", :text => "Create").click
    end
    page.should_not have_content("Purchase")
    page.should have_content("Account Settings")
  end

  it "wont create if customer name is invalid", :js => true  do
    sign_in_rep(:username => "automatictester.rep")
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Create New Document").click

    find("input#customerField").set("NONEXISINGPERSON")
    within("div.submit") do
      find("span.dijitReset.dijitInline.dijitButtonNode", :text => "Create").click
    end

    page.should have_content("New Order")
    within("div.submit") do
      find("span.dijitReset.dijitInline.dijitButtonNode", :text => "Create")
    end
    page.should have_content("Logout")
  end
end
