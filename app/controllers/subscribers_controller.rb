class SubscribersController < ApplicationController
  allow_unauthenticated_access
  before_action :set_product, only: :create

  def create
    @product.subscribers.where(subscriber_params).first_or_create
    redirect_to @product, notice: "You are now subscribed."
  end

  def unsubscribe
    subscriber = Subscriber.find_signed(params[:token])

    if subscriber&.unsubscribe!
      redirect_to root_path, notice: "You have been unsubscribed from these emails."
    else
      redirect_to root_path, alert: "This unsubscribe link is invalid or has expired."
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def subscriber_params
    params.expect(subscriber: [ :email ])
  end
end
