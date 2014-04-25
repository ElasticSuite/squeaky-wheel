require "spec_helper"

describe "The purchase page", :sauce => true do
  it "submits with proper fields filled in", :js => true do
    # WARNING: This submits an order!!!!
    sign_in_rep
    create_order_with_sizes
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Purchase").click
    sleep(0.5)
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
    within("div.actions.dijitDialogPaneActionBar.right") do
      find("span.dijitReset.dijitInline.dijitButtonText", :text => "Submit").click
    end

    page.should have_content("Order submitted successfully.")
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Okay").click
    find("span#finalSubmitButton_label", :text => "Submit Order").click
    page.should have_content("The order has already been submitted")

    destroy_order
  end

  it "Has the appropriate price and unit #s", :js => true do
    sign_in_rep
    create_order_with_sizes
    within("div.cartTotals") do
      @product_price = find("span.priceLabel").value
      within("strong") do
        @product_units = first("span").value
      end
    end
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Purchase").click
    within("div.summary") do
      @product_price == first("span.priceLabel").value
      within("p.quantity") do
        @product_units == first("span").value
      end
    end
    destroy_order
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
  end
end
