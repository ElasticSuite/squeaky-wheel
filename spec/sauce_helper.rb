# You should edit this file with the browsers you wish to use
# For options, check out http://saucelabs.com/docs/platforms
require "sauce"
require "sauce/capybara"
require "capybara/rails"
require "capybara/rspec"

Capybara.default_driver = :sauce
Capybara.app_host = 'http://sharedstaging.tnf.elasticsuite.com/'

Capybara.default_wait_time = 10
Sauce.config do |config|
  config[:browsers] = [
    ["Linux", "Firefox", "27"],
    #["Linux", "Chrome", nil]
  ]
  config[:start_local_application] = false
  # config[:browser_url] = "http://staging.tnf.elasticsuite.com/"
  # config[:application_url] = "http://staging.tnf.elasticsuite.com/"
end
