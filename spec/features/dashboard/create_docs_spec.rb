require "spec_helper"

describe "Within create new document tab" do
  it "has the proper new order options", :js => true do
    sign_in_rep

    dojo_visit('dashboard')
    find("#dijit_form_Button_5_label", :text => "Create New Document").click

    page.should have_content("New Order")
    find_field("Name")
    find("input#customerField")
    find("table#elasticScramble_dashboard_newDocument_catalog")
    find("table#elasticScramble_dashboard_newDocument_custom_catalog")
    find("input#elasticScramble_dashboard_newDocument_start_date")
    find("#dijit_form_Button_33_label", :text => "Create")
    page.should have_content("Logout")
    sign_out
  end

  it "will transition into builder on create", :js => true do
    sign_in_rep
    dojo_visit('dashboard,newDocument')

    find_field("Name").set("Testing Order A")
    find("#dijit_form_Button_33_label", :text => "Create").click

    page.should have_content("Total")
    current_url.split("#")[1] == "builder,browse"
    visit("#dashboard")
    sign_out
  end

  it "wont create if the catalog name is invalid", :js => true  do
    sign_in_rep
    dojo_visit('dashboard,newDocument')

    find_field("Name").set(" ")
    find("#dijit_form_Button_33_label", :text => "Create").click
    page.should have_content("New Order")
    find_field("Name")
    find("#dijit_form_Button_33_label", :text => "Create")

    sign_out
  end

  it "wont create if customer name is invalid", :js => true  do
    sign_in_rep
    dojo_visit('dashboard,newDocument')

    find("#customerField").set(" ")
    find("#dijit_form_Button_33_label", :text => "Create").click
    page.should have_content("New Order")
    find_field("Name")
    find("#dijit_form_Button_33_label", :text => "Create")
    page.should have_content("Logout")
    sign_out
  end
end
