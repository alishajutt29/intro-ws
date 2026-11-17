module Unsubscribable
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where(unsubscribed_at: nil) }
  end

  def unsubscribed?
    unsubscribed_at.present?
  end

  def unsubscribe!(at: Time.current)
    update!(unsubscribed_at: at) unless unsubscribed?
  end

  def unsubscribe_token
    signed_id
  end
end
