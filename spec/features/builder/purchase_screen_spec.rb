require "spec_helper"

describe "The purchase page" do
  it "submits with proper fields filled in", :js => true do
    sign_in_rep
    create_order_with_sizes
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Purchase").click
    page.should have_content("BILLING INFO")
    page.should have_content("Billing Address")
    within("div.addresses.subform") do
      find("div.dijitDownArrowButton").click
      sleep(0.5)
    end
    find("div.dijitMenuItem", :match => :first).click
    within("div.poNumber.field") do
      find("input.dijitReset.dijitInputInner").set("123456")
    end
    find("span#finalSubmitButton_label", :text => "Submit Order").click
    page.should have_content("ORDER SUBMISSION")
    page.should have_content("Your order is about to be submitted.")
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Submit").click

    page.should have_content("Order Submitted")
    page.should have_content("Order submitted successfully. Your order file should begin downloading momentarily.")

    find("Okay").click
    find("span#finalSubmitButton_label", :text => "Submit Order").click
    page.should have_content("The order has already been submitted")

    destroy_order
    sign_out
  end

  it "Has the appropriate price and unit #s", :js => true do
    sign_in_rep
    create_order_with_sizes
    within("div.equation") do
      @product_units = first("span").value
    end
    @product_price = first("span.pricelabel.price").value
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Purchase").click
    within("div.summary") do
      @product_price == first("span.pricelabel").value
      within("p.quantity") do
        @product_units == first("span").value
      end
    end
    destroy_order
    sign_out
  end

  it "wont submit order without fields populated", :js => true do
    sign_in_rep
    create_order_with_sizes
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Purchase").click
    find("span#finalSubmitButton_label", :text => "Submit Order").click
    page.should have_content("Please select a Shipping Address")
    within("div.addresses.subform") do
      find("div.dijitDownArrowButton").click
      sleep(0.5)
    end
    find("div.dijitMenuItem", :match => :first).click
    find("span#finalSubmitButton_label", :text => "Submit Order").click
    page.should have_content("Please enter a PO Number")
    destroy_order
    sign_out
  end
end
