require "spec_helper"

describe "Within the account settings tab", :sauce => true do
  it "fields exist for logged in user", :js => true do
    sign_in_rep

    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Account Settings").click
    page.should have_content("Account Settings")
    page.should have_content("First Name")
    page.should have_content("Last Name")
    page.should have_content("Username")
    page.should have_content("E-mail")
    page.should have_content("Password")
    page.should have_content("Confirm Password")
    page.should have_content("Submit Changes")

  end

  # it "not available for logged out user" do
  #   pending("TODO: dashboard loggin permissioning not setup")
  #   visit "#dashboard,accountSettings"
  #   page.should have_content "Please login to continue"
  # end

  it "fields changed with correct password input", :js => true do
    sign_in_rep

    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Account Settings").click

    page.should have_content("Submit Changes")
    page.should have_content("Confirm")

    fill_in "Password", :with => "testing123"
    fill_in "Confirm Password", :with => "testing123"
    find("#dijit_form_Button_14_label", :text => "Submit Changes").click
    page.should have_content("Submit Changes")
    sign_out
    sign_in_rep(:username => "automatictester.rep", :password => "testing123")
    reset_rep
  end

  it "wont update if password / confirm dont match", :js => true do
    sign_in_rep

    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Account Settings").click
    page.should have_content("Confirm Password")
    page.should have_content("Password")
    fill_in "Password", :with => "sdfsdfs"
    fill_in "Confirm Password", :with => "bnmbnmb"
    find("#dijit_form_Button_14_label", :text => "Submit Changes").click
    page.should have_content("Passwords do not match.")
  end

  it "can change first/last name", :js => true do
    sign_in_rep

    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Account Settings").click
    find_field("First Name")

    fill_in "First Name", :with => "RobotButler"
    find("#dijit_form_Button_14_label", :text => "Submit Changes").click
    page.should have_content("Successfully Updated!")
    find_field("Last Name")
    fill_in "Last Name", :with => "Maximus"
    find("#dijit_form_Button_14_label", :text => "Submit Changes").click
    page.should have_content("Successfully Updated!")
    page.should have_content("RobotButler Maximus")

    reset_rep
  end

  it "can change username", :js => true do
    sign_in_rep

    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Account Settings").click
    find_field("Username")
    page.should have_content("Submit Changes")

    fill_in "Username", :with => "robinski.rep"
    find("#dijit_form_Button_14_label", :text => "Submit Changes").click
    find("#dijit_form_Button_13_label", :text => "Logout")

    find_field("Username").value == "robinski.rep"
    sign_out

    sign_in_rep(:username => "robinski.rep")
    page.should_not have_content('Username and password do not match')
    reset_rep
  end

  it "can change e-mail", :js => true do
    sign_in_rep

    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Account Settings").click
    find_field("E-mail")

    fill_in "E-mail", :with => "random123@example.com"
    find("#dijit_form_Button_14_label", :text => "Submit Changes").click
    find_field("E-mail").value == "random123@example.com"
    page.should have_content("Successfully Updated!")

    reset_rep
  end
end
