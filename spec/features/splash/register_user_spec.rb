require "spec_helper"


describe "Manually registering a user through the splash page", :sauce => true do
  # it "registers with accurate information", :js => true do

  #   c = Fabricate(:customer)

  #   visit "/scramble/index.html#splash,register"

  #   find("#elasticScramble_splash_register_account_number")

  #   fill_in "elasticScramble_splash_register_account_number", with: "25589"
  #   fill_in "elasticScramble_splash_register_access_key", with: "565656"

  #   find("#dijit_form_Button_5_label", :text => "Register").click

  #   page.should_not have_content("There were errors with your registration request")
  #   page.should have_content('First Name')
  #   page.should have_content('Last Name')
  #   page.should have_content('Username')
  #   page.should have_content('Password')
  #   page.should have_content('Confirm Password')
  #   page.should have_content('E-mail')
  #   page.save_screenshot('registercompletd.png')
  # end

  it "fails to register w/o information", :js => true do
    visit("#splash")
    page.should have_content("An account is required to access the")
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Register").click
    page.should have_content("You will need an Account Number and Access Key to register")
  end
end

