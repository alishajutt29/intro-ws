require "test_helper"

class SubscribersControllerTest < ActionDispatch::IntegrationTest
  test "should create subscription for a product" do
    assert_difference("Subscriber.count") do
      post product_subscribers_url(products(:two)), params: { subscriber: { email: "buyer@example.com" } }
    end

    assert_redirected_to product_url(products(:two))
  end

  test "should not duplicate an existing subscription" do
    existing = subscribers(:one)

    assert_no_difference("Subscriber.count") do
      post product_subscribers_url(existing.product), params: { subscriber: { email: existing.email } }
    end
  end

  test "should unsubscribe with a valid signed token" do
    subscriber = subscribers(:one)

    get unsubscribe_url(subscriber.signed_id)

    assert_redirected_to root_url
    assert subscriber.reload.unsubscribed?
  end

  test "should reject an invalid unsubscribe token" do
    get unsubscribe_url("not-a-valid-token")

    assert_redirected_to root_url
    assert_nil flash[:notice]
    assert flash[:alert].present?
  end

  test "back in stock notifies only active subscribers" do
    product = products(:one)
    subscribers(:one).unsubscribe!
    active = product.subscribers.create!(email: "active@example.com")

    product.update!(inventory_count: 0)

    assert_enqueued_jobs 1 do
      product.update!(inventory_count: 4)
    end

    assert_includes product.subscribers.active, active
  end
end
