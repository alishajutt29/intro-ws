ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors, with: :threads)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

module AuthenticationTestHelpers
  TEST_PASSWORD = "password123"

  def create_test_user(email_address: "shopper@example.com")
    User.create!(email_address: email_address, password: TEST_PASSWORD)
  end

  def sign_in_as(user)
    Rails.cache.clear # reset session rate limiting between logins
    post session_path, params: { email_address: user.email_address, password: TEST_PASSWORD }
  end
end

class ActionDispatch::IntegrationTest
  include AuthenticationTestHelpers
end
