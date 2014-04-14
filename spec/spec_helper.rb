# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
end

require "sauce_helper"

def sign_in_rep(args = {})
  args[:username] ||= "automatictester"
  args[:password] ||= "testing"

  visit("#splash")

  find("#widget_elasticScramble_splash_login_username")
  find("#widget_elasticScramble_splash_login_password")

  fill_in "Username",     with: args[:username]
  fill_in "Password",     with: args[:password]

  find("#dijit_form_Button_3", :text => "Login").click
  find("#dijit_form_Button_13_label", :text => "Logout")
end

def dojo_visit(location)
  page.execute_script("elasticScramble.selectedChildren.center.doTransition({target: '#{location}', transition: false});")
end

def sign_out
  dojo_visit("dashboard")
  page.should_not have_content("Checking your credentials...")
  page.should have_css("div.innerBox")
  page.should have_content("Logout", :visible => true)
  page.should have_content("Account Settings")

  within(:css, "div.userStatus") do
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Logout", :visible => true).click
  end
end

def reset_rep
  dojo_visit("dashboard,accountSettings")
  find_field("Confirm Password")
  find_field("First Name")
  find_field("Last Name")
  find_field("Username")
  find_field("E-mail")
  find_field("Password")
  page.should have_content("Submit Changes")
  fill_in "Password", :with => "testing"
  fill_in "Confirm Password", :with => "testing"
  fill_in "Username", :with => "automatictester"
  fill_in "First Name", :with => "Auto"
  fill_in "Last Name", :with => "Tester"
  fill_in "E-mail", :with => "automatictester@elasticsuite.com"
  find("span.dijitReset.dijitInline.dijitButtonText", :text => "Submit Changes").click
  find("span.dijitReset.dijitInline.dijitButtonText", :text => "Submit Changes")
end

def destroy_order
  dojo_visit("dashboard,openFromCloud")

  page.should have_content "Order #"
  page.should have_content "Last Saved"

  within(:css, "div.dgrid-scroller") do
    first(:css, 'span.dijitReset.dijitStretch.dijitButtonContents', :visible => true).click
  end
  within("div.modalConfirm") do
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Yes").click
    sleep(1)
  end
end

def create_order(order_name = "CapyTester")
  dojo_visit("dashboard,newDocument")

  find_field("Name").set("#{order_name}")
  within("div.field.submit") do
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Create").click
  end
  page.should have_content("Total")
  current_url.split("#")[1] == "builder,browse"
  find("span.dijitReset.dijitInline.dijitButtonText", :text => "Menu").click
  find("#dojox_form__BusyButtonMixin_0_text").click
  page.should have_content("Document saved.")
end

def visit_builder
  dojo_visit("dashboard,openFromCloud")
  within("div.dgrid-content.ui-widget-content") do
    within('div.dgrid-row', :match => :first) do
      find("td.field-name").click
    end
  end
end

def create_populated_order(order_name = "KEEP tester order")
  dojo_visit("dashboard,newDocument")
  find_field("Name").set("#{order_name}")
  within("div.field.submit") do
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Create").click
  end
  find("span.dijitReset.dijitInline.dijitButtonText", :text => "Order").click
  within('ul.variations', :match => :first) do
    first("li").click
    sleep(1)
  end
  page.should have_content("has been successfully added")
  find("span.dijitReset.dijitInline.dijitButtonText", :text => "Menu").click
  find("#dojox_form__BusyButtonMixin_0_text").click
  sleep(0.5)
end

def create_order_with_sizes(name = "Purchase Testing")
  create_populated_order(name)
  find("span.dijitReset.dijitInline.dijitButtonText", :text => "Sizing").click
  within("div.row.stockItem", :match => :first) do
    find("input.dijitReset.dijitInputInner").set("1")
  end
end
