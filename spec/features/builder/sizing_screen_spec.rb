require "spec_helper"

describe "The sizing screen" do
  it "can be visited from order page", :js => true do
    sign_in_rep
    create_populated_order
    within("div.childViewButtons") do
      find("span.dijitReset.dijitButtonText", :text => "Sizing").click
    end
    page.should have_content("Quick Add")
    page.should have_content("Units:0")
    destroy_order
    sign_out
  end

  it "has items added to cart previously", :js => true do
    sign_in_rep
    create_populated_order
    within("div.details", :match => :first) do
      @s3_prod_url = find("img")['src']
    end
    within("div.childViewButtons") do
      find("span.dijitReset.dijitButtonText", :text => "Sizing").click
    end
    within("div.details", :match => :first) do
      @s3_prod_url == find("img")['src']
    end
    destroy_order
    sign_out
  end

  it "add amounts updates price and # units", :js => true do
    sign_in_rep
    create_populated_order
    dojo_visit("builder,sizing")
    first("span.priceLabel").value == "$0.00"
    within("div.row.stockItem", :match => :first) do
      find("input.dijitReset.dijitInputInner").set("1")
    end
    find("p.units").click
    find("p.units").value == "Units:1"
    first("span.priceLabel").value != "$0.00"
    destroy_order
    sign_out
  end

  it "can add amounts to size variants", :js => true do
    pending
  end

  it "can remove a product from their list", :js => true do
    sign_in_rep
    create_populated_order
    dojo_visit("builder,sizing")
    within("div.variationItems", :match => :first) do
      page.should have_content("Units")
      page.should have_content("$")
      find("span.dijitReset.dijitStretch.dijitButtonContents").click
    end
    page.should_not have_css("div.variationItems")
    destroy_order
    sign_out
  end
end

