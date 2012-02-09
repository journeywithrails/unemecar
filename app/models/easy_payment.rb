class EasyPayment < ActiveRecord::Base
  validates_presence_of :name, :last_name, :age_on_raceday, :sex, :email, :shirt_size
  
  def paypal_encrypted(return_rul, notify_url, payment_info)
    values = {
      :business => APP_CONFIG[:paypal_email],
      :cmd => '_cart',
      :upload => 1,
      #:return => "http://apps.facebook.com/pdm_racemenu/easy_payments/",
      :return => "http://apps.facebook.com/racemenu/easy_payments/",
      :invoice => payment_info.user_id,
      #:notify_url => "http://web1.tunnlr.com:10387/payment_notifications",
      :notify_url => "http://racemenu.com/payment_notifications",
      :cert_id => APP_CONFIG[:paypal_cert_id]
      
    }
    line_items = []
    line_items[0] = {:unit_price=>"10.00", :product_name=>"Race Registration", :id=>"1", :quantity=>"1"}
    line_items.each_with_index do |item, index|
      values.merge!({
        "amount_#{index+1}" => 10.00,
        "item_name_#{index+1}" => "Race Registration (" + payment_info.name + ")",
        "item_number_#{index+1}" => payment_info.user_id,
        "quantity_#{index+1}" => 1
      })
    end
    #@link = "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
    encrypt_for_paypal(values)
  end


  PAYPAL_CERT_PEM = File.read("#{Rails.root}/certs/paypal_cert.pem")
  APP_CERT_PEM = File.read("#{Rails.root}/certs/app_cert.pem")
  APP_KEY_PEM = File.read("#{Rails.root}/certs/app_key.pem")

  def encrypt_for_paypal(values)
    signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(APP_CERT_PEM), OpenSSL::PKey::RSA.new(APP_KEY_PEM, ''), values.map { |k, v| "#{k}=#{v}" }.join("\n"), [], OpenSSL::PKCS7::BINARY)
    OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(PAYPAL_CERT_PEM)], signed.to_der, OpenSSL::Cipher::Cipher::new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
  end

end
