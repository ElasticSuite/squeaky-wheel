require "spec_helper"

describe "A full page walkthrough" do
  it "can do it all", :js => true do
    sign_in_rep

    # Check dashboard buttons
    find('span.dijitReset.dijitInline.dijitButtonNode', :text => "Create New Document")
    find('span.dijitReset.dijitInline.dijitButtonNode', :text => "Open From Cloud")
    find('span.dijitReset.dijitInline.dijitButtonNode', :text => "Open From Desktop")
    find('span.dijitReset.dijitInline.dijitButtonNode', :text => "Manage Catalogs")
    find('span.dijitReset.dijitInline.dijitButtonNode', :text => "Print Jobs")
    find('span.dijitReset.dijitInline.dijitButtonNode', :text => "Support")
    find('span.dijitReset.dijitInline.dijitButtonNode', :text => "Account Settings")
    find('span.dijitReset.dijitInline.dijitButtonNode', :text => "Logout")

    # Check Account Settings changes
    dojo_visit('dashboard,accountSettings')
    page.should have_content("Account Settings")
    page.should have_content("First Name")
    page.should have_content("Last Name")
    page.should have_content("Username")
    page.should have_content("E-mail")
    page.should have_content("Password")
    page.should have_content("Confirm Password")
    page.should have_content("Submit Changes")
    fill_in "Password", :with => "testing123"
    fill_in "Confirm Password", :with => "testing123"
    fill_in "First Name", :with => "RobotButler"
    fill_in "Last Name", :with => "Maximus"
    fill_in "Username", :with => "robinski.rep"
    fill_in "E-mail", :with => "random123@example.com"
    find("#dijit_form_Button_14_label", :text => "Submit Changes").click
    page.should have_content("Successfully Updated!")
    reset_rep

    # Check Order creation
    create_order("SmokeTesting")
    within("div#dijit__Container_0.childViewButtons") do
      find("span.dijitReset.dijitInline.dijitButtonText", :text => "Order").click
    end
    page.should have_content("General Filters")
    page.should have_content("Results:")
    within('ul.variations', :match => :first) do
      first("li").click
      sleep(1)
    end
    page.should have_content("has been successfully added")

    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Menu").click
    find("#dojox_form__BusyButtonMixin_0_text").click
    sleep(1)
    page.should have_content("Document saved.")

    # Open saved order from cloud
    dojo_visit("dashboard")
    find('span.dijitReset.dijitInline.dijitButtonNode', :text => "Open From Cloud").click
    within("div.dgrid-content.ui-widget-content") do
      within('div.dgrid-row', :match => :first) do
        find("td.field-name").value == "SmokeTesting"
        find("td.field-updated_at").value == Time.now.strftime("%m/%d/%y")
        first("td").click
      end
    end
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Save").click
    within("div#dijit__Container_0.childViewButtons") do
      find("span.dijitReset.dijitInline.dijitButtonText", :text => "Order").click
    end
    page.should have_content "Total"
    page.should have_content("General Filters")
    page.should have_content("Results:")
    find('ul.variations', :match => :first)

    # Add item to order
    within('ul.variations', :match => :first) do
      first("li").click
    end
    page.should have_content("has been successfully added")

    # Add size for item
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Sizing").click
    within("div.row.stockItem", :match => :first) do
      find("input.dijitReset.dijitInputInner").set("1")
    end

    # fill out purchase dropdowns
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Purchase").click
    page.should have_content("BILLING INFO")
    page.should have_content("Billing Address")
    within("div.addresses.subform") do
      find("div.dijitDownArrowButton").click
      sleep(0.5)
    end
    find("div.dijitMenuItem", :match => :first).click
    find("span#finalSubmitButton_label", :text => "Submit Order").click
    page.should have_content("Please enter a PO Number")

    # Delete most recently saved order
    dojo_visit("dashboard,openFromCloud")
    within("div.dgrid-content.ui-widget-content") do
      within('div.dgrid-row', :match => :first) do
        first("span.dijitReset.dijitStretch.dijitButtonContents").click
      end
    end

    within("div.dijitDialog.dijitDialogFixed") do
      find("span.dijitReset.dijitInline.dijitButtonText", :text => "Yes").click
    end
    sleep(1)
    sign_out
  end
end
