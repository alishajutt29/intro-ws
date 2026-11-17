require "test_helper"

class ProductMailerTest < ActionMailer::TestCase
  test "in_stock" do
    mail = ProductMailer.with(
      product: products(:one),
      subscriber: subscribers(:one)
    ).in_stock

    assert_equal "Widget is back in stock", mail.subject
    assert_equal [ subscribers(:one).email ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Widget", mail.body.encoded
    assert_match "Unsubscribe", mail.body.encoded
  end
end
