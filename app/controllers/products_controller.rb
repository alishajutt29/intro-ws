class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  allow_unauthenticated_access only: %i[index show]
  def index
    @categories = Category.order(:name)
    @products = Product.includes(:category).all

    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to @product
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
  def product_params
  params.expect(product: [
    :name,
    :category_id,
    :description,
    :featured_image,
    :inventory_count
  ])
  end
end
