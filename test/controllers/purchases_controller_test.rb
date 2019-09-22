

require 'test_helper'
require 'stripe'

class PurchasesControllerTest < ActionController::TestCase

	 include ActiveJob::TestHelper

  setup do
    @purchases = purchases(:one)
    @purchaser = users(:two) # user 2 is the customer
    @seller = users(:one)
    @token = Stripe::Token.create(card: { number: '4242424242424242',
                                                 exp_month: 8, exp_year: 2050,
                                                 cvc: 132})
    @purchase_info ={ user_id: @purchaser.id,
                      author_id: users(:one).id,
                                   stripe_customer_token: @purchaser.stripe_customer_token,
                                   stripe_card_token: @token.id,
                                   pricesold: 10 }
    @customer = Stripe::Customer.create(description: @purchaser.name,
        																email: @purchaser.email)
 		 @merchandise = merchandises(:one)
     @donation_merchandise = merchandises(:seven)
  end

  test 'should_get_purchases_new_purchase' do
    @merchandises = merchandises(:one)
    sign_in users(:two)
    get :new, params: { merchandise_id: @merchandises.id }
    assert_response :success
  end

  test 'should_get_purchases_new_donate' do
    sign_in users(:two)
    seller = users(:one)
    merch = merchandises(:two)
    get :new, params: { pricesold: 25, author_id: seller.id, merchandise: merch }
    assert_response :success
  end
  test 'should_get_purchases_show' do
    sign_in users(:one)
    get :show, params: { id: @purchases.id }
    assert_response :success
  end

  test 'test user should get correct seller for purchased merchandise' do
    sign_in users(:one)
    purchase_demo = purchases(:one)
    get :show, params: { id: purchase_demo.id }
    assert_equal(purchase_demo.merchandise.user_id, 2, msg = nil)
  end

  test 'test user should get correct button type for the purchase' do
    sign_in users(:one)
    purchase_demo = purchases(:one)
    get :show, params: { id: purchase_demo.id }
    assert_equal(purchase_demo.merchandise.buttontype, 'Donate', msg = nil)
  end

  test 'test user should get correct merchandise price for the purchase' do
    sign_in users(:one)
    purchase_demo = purchases(:two)
    get :show, params: { id: purchase_demo.id }
    assert_equal(purchase_demo.merchandise.price, 1.5, msg = nil)
  end

  test 'test user should get correct pricesold for the purchase' do
    sign_in users(:one)
    purchase_demo = purchases(:two)
    get :show, params: { id: purchase_demo.id }
    assert_equal(purchase_demo.pricesold, 50.5, msg = nil)
  end

  test 'test user should get correct authorcut for the purchase' do
    sign_in users(:one)
    purchase_demo = purchases(:two)
    get :show, params: { id: purchase_demo.id }
    assert_equal(purchase_demo.authorcut, 38.1, msg = nil)
  end

  test 'test to check if the show function checks merchandise type correctly' do
    sign_in users(:one)
    purchase_demo = purchases(:one)
    get :show, params: { id: purchase_demo.id }
    refute_equal(purchase_demo.merchandise_id, nil, msg = nil)
  end

  test 'user tries to purchase something from himself/herself' do
    sign_in users(:one)
    seller = users(:one)
    merch = merchandises(:one)
    get :new, params: { pricesold: 25, author_id: seller.id, merchandise: merch }
    assert_response :success
  end

  test 'purchase with merchandise sends mail' do
    @purchase_info[:merchandise_id] = merchandises(:one).id 
    post :create, params: { purchase: @purchase_info }
      assert_enqueued_jobs(2)
    # There should be 2 emails in the box one for each seller one for buyer
  end

  test 'donation sends mail' do
    sign_in @purchaser
    @purchase_info[:merchandise_id] = @donation_merchandise.id
    @customer.save
    post :create, params: { purchase: @purchase_info } 
      assert_enqueued_jobs(2)
  end
end
