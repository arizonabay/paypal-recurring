module PayPal
  module Recurring
    module Response
      class BillingAgreement < Base
        def confirmation_url
          "#{PayPal::Recurring.site_endpoint}?cmd=_customer-billing-agreement&token=#{token}"
        end
      end
    end
  end
end
