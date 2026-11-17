class Subscriber < ApplicationRecord
  include Unsubscribable

  belongs_to :product
  validates :email, presence: true, format: URI::MailTo::EMAIL_REGEXP
end
