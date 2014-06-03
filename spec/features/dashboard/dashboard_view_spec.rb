require "spec_helper"

describe "Within the dashboard upon login", :sauce => ENV['ON_SAUCE'] do
  it "has the requisite links", :js => true do
    sign_in_rep

    within(:css, "ul.buttonList") do
      find("span.dijitReset.dijitInline.dijitButtonNode", :text => "Create New Document")
      find("span.dijitReset.dijitInline.dijitButtonNode", :text => "Open From Cloud")
      find("span.dijitReset.dijitInline.dijitButtonNode", :text => "Open From Desktop")
      find("span.dijitReset.dijitInline.dijitButtonNode", :text => "Manage Catalogs")
      find("span.dijitReset.dijitInline.dijitButtonNode", :text => "Print Jobs")
      find("span.dijitReset.dijitInline.dijitButtonNode", :text => "Support")
      find("span.dijitReset.dijitInline.dijitButtonNode", :text => "Account Settings")
    end
  end
end
