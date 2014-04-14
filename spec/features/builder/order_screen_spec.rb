require "spec_helper"

describe "The order tab in builder" do
  it "can add items to order", :js => true do

    sign_in_rep
    create_order
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Order").click

    page.should have_content("General Filters")
    page.should have_content("Results:")
    within('ul.variations', :match => :first) do
      first("li").click
      sleep(1)
    end
    page.should have_content("has been successfully added")
    destroy_order
    sign_out
  end

  it "cant add the same item twice", :js => true do
    sign_in_rep
    create_order
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Order").click

    page.should have_content("General Filters")
    page.should have_content("Results:")
    within('ul.variations', :match => :first) do
      first("li").click
      sleep(1)
    end
    page.should have_content("has been successfully added")

    within('ul.variations', :match => :first) do
      first("li").click
      sleep(1)
    end
    page.should have_content("This product is already in your cart")
    page.should_not have_content("has been successfully added")
    destroy_order
    sign_out
  end
end

# .trigger('mousedown')
