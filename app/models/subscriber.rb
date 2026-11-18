
class Subscriber < ApplicationRecord
  include Unsubscribable

  belongs_to :product

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  generates_token_for :unsubscribe
end
