require "spec_helper"

describe "Within the dashboard upon login" do
  it "has the requisite links", :js => true do
    sign_in_rep
    dojo_visit('dashboard')

    within(:css, "ul.buttonList") do
      page.has_css?('#dijit_form_Button_7_label', :text => "Create New Document")
      page.has_css?('#dijit_form_Button_8_label', :text => "Open From Cloud")
      page.has_css?('#dijit_form_Button_9_label', :text => "Open From Dealer")
      page.has_css?('#dijit_form_Button_10_label', :text => "Open From Desktop")
      page.has_css?('#dijit_form_Button_11_label', :text => "Manage Catalogs")
      page.has_css?('#dijit_form_Button_12_label', :text => "Print Jobs")
      page.has_css?('#dijit_form_Button_13_label', :text => "Support")
      page.has_css?('#dijit_form_Button_14_label', :text => "Account Settings")
      page.has_css?('#dijit_form_Button_15_label', :text => "Logout")
    end

    page.has_css?("div#dijit_layout_ContentPane_4.titleBar")
    sign_out
  end
end
