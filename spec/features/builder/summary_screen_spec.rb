require "spec_helper"

describe "The Summary page", :sauce => ENV['ON_SAUCE'] do
  it "has all summary columns", :js => true do
    sign_in_rep
    create_order
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Summary").click
    page.should have_content("Category")
    page.should have_content("Quantity")
    page.should have_content("Price")
    within("div.typeButtons") do
      find("input.dijitReset.dijitInputField.dijitArrowButtonInner").click
    end
    page.should have_content("Select Summary Column(s)")
    page.should have_content("Special Groupings")
    page.should have_content("Workbook")
    page.should have_content("Abm")
    page.should have_content("Sbu")
    page.should have_content("Gender")
    page.should have_content("Color")

    destroy_order
  end

  it "quantity and price add to 100%", :js => true do
    sign_in_rep
    create_order_with_sizes
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

    destroy_order
  end

  # it "populates columns when selected from dropdown", :js => true do
  #   pending
  #   sign_in_rep
  #   create_order
  #   destroy_order
  #   sign_out
  # end

  # it "has total orders", :js => true do
  # end

  # it "has page 1 orders only if selected", :js => true do
  # end
end
