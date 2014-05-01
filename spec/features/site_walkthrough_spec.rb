require "spec_helper"

describe "A full page walkthrough", :sauce => true do
  it "can create/populate/send an order", :js => true do
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

    # Check Order creation
    create_order("SmokeTesting")
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Order").click
    page.should have_content("General Filters")
    page.should have_content("Results:")
    within('ul.variations', :match => :first) do
      first("li").click
    end
    page.should have_content("has been successfully added")

    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Menu").click
    first("td", :text => "Save").click
    page.should have_content("Document saved.")

    # Open saved order from cloud
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Menu").click
    find("td", :text => "Open From Cloud").click
    within("div.dgrid-content.ui-widget-content") do
      within('div.dgrid-row', :match => :first) do
        find("td.field-name").value == "SmokeTesting"
        find("td.field-updated_at").value == Time.now.strftime("%m/%d/%y")
        first("td").click
      end
    end
    page.should have_content "Browse"
    page.should have_content "Items"
    page.should have_content "Total"

    # Add size for item
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Sizing").click
    first("span.priceLabel").value == "$0.00"
    within("div.row.stockItem", :match => :first) do
      find("input.dijitReset.dijitInputInner").set("1")
    end
    find("p.units").click
    find("p.units").value == "Units:1"
    first("span.priceLabel").value != "$0.00"

    # Summary of order shows up

    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Summary").click
    page.should have_content("Quantity")
    page.should have_content("Category")
    @quantity = 0
    @price = 0
    all("td.column.quantityPercent").each do |num|
      @quantity += (num.to_s.split("%")[0]).to_i
    end
    @quantity == 100
    all("td.column.pricePercent").each do |num|
      @price += (num.to_s.split("%")[0]).to_i
    end
    @price == 100

    # Can send an order on the purchase page
    # WARNING: THIS WILL SEND AN ORDER

    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Purchase").click
    page.should have_content("BILLING INFO")
    page.should have_content("Billing Address")
    within("div.addresses.subform") do
      find("div.dijitDownArrowButton").click
    end
    find("div.dijitMenuItem", :match => :first).click
    within("div.poNumber.field") do
      find("input.dijitReset.dijitInputInner").set("123456")
    end
    find("span#finalSubmitButton_label", :text => "Submit Order").click
    page.should have_content("ORDER SUBMISSION")
    page.should have_content("Your order is about to be submitted.")
    within("div.actions.dijitDialogPaneActionBar.right") do
      find("span.dijitReset.dijitInline.dijitButtonText", :text => "Submit").click
    end

    page.should have_content("Order submitted successfully.")
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Okay").click
    find("span#finalSubmitButton_label", :text => "Submit Order").click
    page.should have_content("This order has already been submitted")
  end

  it "can save/modify/delete an order", :js => true do
    sign_in_rep

    # Check Account Settings changes

    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Account Settings").click
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
    fill_in "Username", :with => "modifiedautouser"
    fill_in "E-mail", :with => "random123@example.com"
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Submit Changes").click
    page.should have_content("Successfully Updated!")
    reset_rep

    # Delete most recently saved order
    create_order
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Menu").click
    find("td", :text => "Open From Cloud").click

    page.should have_content("Total")
    page.should have_content("Last Saved")

    within(:css, "div.dgrid-scroller") do
      first(:css, 'span.dijitReset.close').click
    end
    within("div.modalConfirm") do
      find("span.dijitReset.dijitInline.dijitButtonText", :text => "Yes").click
    end
    page.should have_content("Document removed.")

    sign_out
  end
end
