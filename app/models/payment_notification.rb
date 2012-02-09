class PaymentNotification < ActiveRecord::Base
  #belongs_to :cart
  serialize :params
  after_create :mark_cart_as_purchased

  private

  def mark_cart_as_purchased
    if status == "Completed"
      #still needs this to be implemented for perfect security - not done because colin wants to see for tonigh: && params[:secret] == APP_CONFIG[:paypal_secret]
      #cart.update_attribute(:purchased_at, Time.now)
      EasyPayment.find_by_user_id(PaymentNotification.last.params.invoice).update_attribute(:paid, "1")
    end
    if status == "Pending"
      #still needs this to be implemented for perfect security - not done because colin wants to see for tonigh: && params[:secret] == APP_CONFIG[:paypal_secret]
      #cart.update_attribute(:purchased_at, Time.now)
      EasyPayment.find_by_user_id(PaymentNotification.last.params.invoice).update_attribute(:paid, "2")
    end    
    
    
  end
  
end
