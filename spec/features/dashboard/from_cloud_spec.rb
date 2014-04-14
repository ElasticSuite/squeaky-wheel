require "spec_helper"

describe "Within the open from cloud tab" do
  it "new catalogs show correct name / updated day", :js => true do
    sign_in_rep
    create_order
    dojo_visit('dashboard,openFromCloud')

    within('div[id^="dgrid_0-row"]', :match => :first) do
      find("td.field-name").value == "CapyTester"
      find("td.field-updated_at").value == Time.now.strftime("%m/%d/%y")
    end
    destroy_order
    sign_out
  end
end
