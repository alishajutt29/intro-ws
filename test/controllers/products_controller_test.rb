require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create_test_user
  end

  test "should get index without signing in" do
    get products_url
    assert_response :success
  end

  test "should get index filtered by category" do
    get products_url(category_id: categories(:one).id)
    assert_response :success
  end

  test "should get show without signing in" do
    get product_url(products(:one))
    assert_response :success
  end

  test "should require authentication for new product" do
    get new_product_url
    assert_redirected_to new_session_url
  end

  test "should get new when signed in" do
    sign_in_as(@user)
    get new_product_url
    assert_response :success
  end

  test "should get edit when signed in" do
    sign_in_as(@user)
    get edit_product_url(products(:one))
    assert_response :success
  end

  test "should create product when signed in" do
    sign_in_as(@user)

    assert_difference("Product.count") do
      post products_url, params: { product: { name: "New Product", category_id: categories(:one).id } }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should not create product without name" do
    sign_in_as(@user)

    assert_no_difference("Product.count") do
      post products_url, params: { product: { name: "", category_id: categories(:one).id } }
    end

    assert_response :unprocessable_entity
  end

  test "should update product when signed in" do
    sign_in_as(@user)

    patch product_url(products(:one)), params: { product: { name: "Updated", category_id: categories(:one).id } }
    assert_redirected_to product_url(products(:one))
    assert_equal "Updated", products(:one).reload.name
  end

  test "should destroy product when signed in" do
    sign_in_as(@user)

    assert_difference("Product.count", -1) do
      delete product_url(products(:one))
    end

    assert_redirected_to products_url
  end
end
