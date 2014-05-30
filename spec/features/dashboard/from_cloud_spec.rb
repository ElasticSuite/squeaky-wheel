require "spec_helper"

describe "Within the open from cloud tab", :sauce => true do
  it "new catalogs show correct name / updated day", :js => true do
    sign_in_rep
    create_order

    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Menu").click
    find("td.dijitMenuItemLabel", :text => "Close").click
    find("span.dijitReset.dijitInline.dijitButtonNode", :text => "Open From Cloud").click

    within('div[id^="dgrid_0-row"]', :match => :first) do
      find("td.field-name").value == "CapyTester"
      find("td.field-updated_at").value == Time.now.strftime("%m/%d/%y")
      find("span.dijitReset.close").click
    end
    within("div.modalConfirm") do
      find("span.dijitReset.dijitInline.dijitButtonText", :text => "Yes").click
    end
    page.should have_content("Document removed.")
  end

  it "orders can be destroyed", :js => true do
    sign_in_rep
    create_order("CLOUDdeleteCHECK")
    find("span.dijitReset.dijitInline.dijitButtonText", :text => "Menu").click
    find("td.dijitMenuItemLabel", :text => "Open From Cloud").click

    page.should have_content "Order #"
    page.should have_content "Last Saved"

    within(:css, "div.dgrid-scroller") do
      first(:css, 'span.dijitReset.close').click
    end
    within("div.modalConfirm") do
      find("span.dijitReset.dijitInline.dijitButtonText", :text => "Yes").click
    end
    page.should have_content("Document removed.")
    page.should_not have_content("CLOUDdeleteCHECK")
  end
end
