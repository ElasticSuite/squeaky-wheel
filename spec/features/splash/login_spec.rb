require "spec_helper"

describe 'a visitor on the splash page', :sauce => true do
  it 'can login with correct information', :js => true do
    visit("#splash")
    page.should have_content('An account is required to access the The North Face website.')

    fill_in "Username", :with => "automatictester"
    fill_in "Password", :with => "testing"

    find("#dijit_form_Button_3_label", :text => "Login").click

    page.should have_content("Create New Document")
    page.should have_content("Open From Cloud")
    page.should have_content("Open From Desktop")
    page.should have_content("Manage Catalogs")
    page.should have_content("Print Jobs")
    page.should have_content("Support")
    page.should have_content("Account Settings")
    page.should have_content("Logout")
    page.should_not have_content('Username and password do not match')

    # sign_out
  end

  it "cant log with no information", :js => true do
    visit("#splash,login")

    page.should have_content('An account is required to access the The North Face website.')
    page.should have_content('Register')
    page.should_not have_content("You will need an Account Number and Access Key to register")

    find("span#dijit_form_Button_3_label.dijitReset", :text => "Login").click
    page.should have_content("Login")
    # TODO: error message for click w/o input
  end

  it "cant log with incorrect info", :js => true do
    visit("#splash,login")
    page.should_not have_content("You will need an Account Number and Access Key to register")

    page.should have_content('An account is required to access the ')
    page.should have_content('Register')

    fill_in "Username", :with => "asdfasf"
    fill_in "Password", :with => "notarealpassword"

    find("span#dijit_form_Button_3_label.dijitReset", :text => "Login").click

    page.should have_content('Username and password do not match')
    page.should have_content("Login")
  end
end
