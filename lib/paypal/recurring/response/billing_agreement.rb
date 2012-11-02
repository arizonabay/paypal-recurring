module PayPal
  module Recurring
    module Response
      class BillingAgreement < Base

        mapping(
          :status       => :CHECKOUTSTATUS,
          :email        => :EMAIL,
          :email        => :EMAIL,
          :payer_id     => :PAYERID,
          :payer_status => :PAYERSTATUS,
          :first_name   => :FIRSTNAME,
          :last_name    => :LASTNAME,
          :country      => :COUNTRYCODE,
          :currency     => :CURRENCYCODE,
          :amount       => :AMT,
          :description  => :DESC,
          :ipn_url      => :NOTIFYURL
        )
        
        def confirmation_url
          "#{PayPal::Recurring.site_endpoint}?cmd=_customer-billing-agreement&token=#{token}"
        end
      end
    end
  end
end
