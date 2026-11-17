require "test_helper"

class SubscriberTest < ActiveSupport::TestCase
  test "requires a valid email" do
    subscriber = Subscriber.new(product: products(:one), email: "")
    assert_not subscriber.valid?
    assert subscriber.errors[:email].any?

    subscriber.email = "not-an-email"
    assert_not subscriber.valid?

    subscriber.email = "ok@example.com"
    assert subscriber.valid?
  end

  test "unsubscribe! marks the subscriber as unsubscribed" do
    subscriber = subscribers(:one)
    assert_not subscriber.unsubscribed?

    subscriber.unsubscribe!
    assert subscriber.unsubscribed?
    assert_not_nil subscriber.unsubscribed_at
  end

  test "unsubscribe! is idempotent" do
    subscriber = subscribers(:one)
    subscriber.unsubscribe!
    first_time = subscriber.unsubscribed_at

    subscriber.unsubscribe!
    assert_equal first_time, subscriber.unsubscribed_at
  end

  test "active scope excludes unsubscribed subscribers" do
    subscribers(:one).unsubscribe!

    assert_includes Subscriber.active, subscribers(:two)
    assert_not_includes Subscriber.active, subscribers(:one)
  end

  test "unsubscribe_token round trips through signed_id" do
    subscriber = subscribers(:one)
    assert_equal subscriber, Subscriber.find_signed(subscriber.unsubscribe_token)
  end
end
