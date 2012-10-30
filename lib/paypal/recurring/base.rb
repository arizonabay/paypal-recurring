module PayPal
  module Recurring
    class Base
      attr_accessor :amount
      attr_accessor :cancel_url
      attr_accessor :currency
      attr_accessor :description
      attr_accessor :note
      attr_accessor :email
      attr_accessor :failed
      attr_accessor :frequency
      attr_accessor :initial_amount
      attr_accessor :initial_amount_action
      attr_accessor :ipn_url
      attr_accessor :locale
      attr_accessor :outstanding
      attr_accessor :payer_id
      attr_accessor :period
      attr_accessor :profile_id
      attr_accessor :reference
      attr_accessor :refund_type
      attr_accessor :return_url
      attr_accessor :start_at
      attr_accessor :token
      attr_accessor :transaction_id
      attr_accessor :item_category
      attr_accessor :item_name
      attr_accessor :item_amount
      attr_accessor :item_quantity
      attr_accessor :trial_frequency
      attr_accessor :trial_length
      attr_accessor :trial_period
      attr_accessor :trial_amount

      def initialize(options = {})
        options.each {|name, value| send("#{name}=", value)}
      end

      # Just a shortcut convenience.
      #
      def request # :nodoc:
        @request ||= Request.new
      end

      # Request a checkout token.
      #
      #   ppr = PayPal::Recurring.new({
      #     :return_url         => "http://example.com/checkout/thank_you",
      #     :cancel_url         => "http://example.com/checkout/canceled",
      #     :ipn_url            => "http://example.com/paypal/ipn",
      #     :description        => "Awesome - Monthly Subscription",
      #     :amount             => "9.00",
      #     :currency           => "USD"
      #   })
      #
      #   response = ppr.request_token
      #   response.checkout_url
      #
      def checkout
        params = collect(
          :locale,
          :amount,
          :return_url,
          :cancel_url,
          :currency,
          :description,
          :ipn_url,
          :item_category,
          :item_name,
          :item_amount,
          :item_quantity
        ).merge(
          :payment_action => "Authorization",
          :no_shipping => 1,
          :L_BILLINGTYPE0 => "RecurringPayments"
        )

        request.run(:checkout, params)
      end

      # Suspend a recurring profile.
      # Suspended profiles can be reactivated.
      #
      #   ppr = PayPal::Recurring.new(:profile_id => "I-HYRKXBMNLFSK")
      #   response = ppr.suspend
      #
      def suspend
        request.run(:manage_profile, :action => :suspend, :profile_id => profile_id)
      end

      # Reactivate a suspended recurring profile.
      #
      #   ppr = PayPal::Recurring.new(:profile_id => "I-HYRKXBMNLFSK")
      #   response = ppr.reactivate
      #
      def reactivate
        request.run(:manage_profile, :action => :reactivate, :profile_id => profile_id)
      end

      # Cancel a recurring profile.
      # Cancelled profiles cannot be reactivated.
      #
      #   ppr = PayPal::Recurring.new(:profile_id => "I-HYRKXBMNLFSK")
      #   response = ppr.cancel
      #
      def cancel
        request.run(:manage_profile, :action => :cancel, :profile_id => profile_id)
      end

      # Return checkout details.
      #
      #   ppr = PayPal::Recurring.new(:token => "EC-6LX60229XS426623E")
      #   response = ppr.checkout_details
      #
      def checkout_details
        request.run(:details, :token => token)
      end

      # Request payment.
      #
      #   # ppr = PayPal::Recurring.new({
      #     :token       => "EC-6LX60229XS426623E",
      #     :payer_id    => "WTTS5KC2T46YU",
      #     :amount      => "9.00",
      #     :description => "Awesome - Monthly Subscription"
      #   })
      #   response = ppr.request_payment
      #   response.completed? && response.approved?
      #
      def request_payment
        params = collect(
          :amount,
          :return_url,
          :cancel_url,
          :ipn_url,
          :currency,
          :description,
          :payer_id,
          :token,
          :reference,
          :item_category,
          :item_name,
          :item_amount,
          :item_quantity
        ).merge(:payment_action => "Sale")

        request.run(:payment, params)
      end

      # Create a recurring billing profile.
      #
      #   ppr = PayPal::Recurring.new({
      #     :amount                => "9.00",
      #     :initial_amount        => "9.00",
      #     :initial_amount_action => :cancel,
      #     :currency              => "USD",
      #     :description           => "Awesome - Monthly Subscription",
      #     :ipn_url               => "http://example.com/paypal/ipn",
      #     :frequency             => 1,
      #     :token                 => "EC-05C46042TU8306821",
      #     :period                => :monthly,
      #     :reference             => "1234",
      #     :payer_id              => "WTTS5KC2T46YU",
      #     :start_at              => Time.now,
      #     :failed                => 1,
      #     :outstanding           => :next_billing,
      #     :trial_period          => :monthly,
      #     :trial_length          => 1,
      #     :trial_frequency       => 1,
      #     :trial_amount          => 0.00
      #   })
      #
      #   response = ppr.create_recurring_profile
      #
      def create_recurring_profile
        params = collect(
          :amount,
          :initial_amount,
          :initial_amount_action,
          :currency,
          :description,
          :payer_id,
          :token,
          :reference,
          :start_at,
          :failed,
          :outstanding,
          :ipn_url,
          :frequency,
          :period,
          :email,
          :trial_length,
          :trial_period,
          :trial_frequency,
          :trial_amount,
          :item_category,
          :item_name,
          :item_amount,
          :item_quantity
        )
        request.run(:create_profile, params)
      end

      # Update a recurring billing profile.
      #
      #   ppr = PayPal::Recurring.new({
      #     :amount                => "99.00",
      #     :currency              => "USD",
      #     :description           => "Awesome - Monthly Subscription",
      #     :note                  => "Changed plan to Gold",
      #     :ipn_url               => "http://example.com/paypal/ipn",
      #     :reference             => "1234",
      #     :profile_id            => "I-VCEL6TRG35CU",
      #     :start_at              => Time.now,
      #     :outstanding           => :next_billing
      #   })
      #
      #   response = ppr.update_recurring_profile
      #
      def update_recurring_profile
        params = collect(
          :amount,
          :currency,
          :description,
          :note,
          :profile_id,
          :reference,
          :start_at,
          :outstanding,
          :ipn_url,
          :email
        )

        request.run(:update_profile, params)
      end

      # Retrieve information about existing recurring profile.
      #
      #   ppr = PayPal::Recurring.new(:profile_id => "I-VCEL6TRG35CU")
      #   response = ppr.profile
      #
      def profile
        request.run(:profile, :profile_id => profile_id)
      end

      # Request a refund.
      #   ppr = PayPal::Recurring.new({
      #     :profile_id => "I-VCEL6TRG35CU",
      #     :transaction_id => "ABCEDFGH",
      #     :reference      => "1234",
      #     :refund_type    => :partial,
      #     :amount         => "9.00",
      #     :currency       => "USD"
      #   })
      #   response = ppr.refund
      #
      def refund
        params = collect(
          :transaction_id,
          :reference,
          :refund_type,
          :amount,
          :currency,
          :note
        )

        request.run(:refund, params)
      end

      # "SetCustomerBillingAgreement"
      def billing_agreement
        params = collect(
          :return_url,
          :cancel_url                         
        ).merge(
         :BILLINGTYPE => "MerchantInitiatedBilling"
        )
        
        request.run(:billing_agreement, params)        
      end

      #"GetBillingAgreementCustomerDetails"
      def billing_agreement_details
        params = collect(:token)
        
        request.run(:billing_agreement_details, params)        
      end
      

      #"CreateBillingAgreement"
      def create_billing_agreement
         params = collect(:token)
        
        request.run(:create_billing_agreement, params)        
      end

      "BillAgreementUpdate"
      def cancel_billing_agreement
        params = collect(:billing_agreement_id).merge(:BillingAgreementStatus => "Canceled")

        request.run(:cancel_billing_agreement, params)        
      end
      
      private
      # Collect specified attributes and build a hash out of it.
      #
      def collect(*args) # :nodoc:
        args.inject({}) do |buffer, attr_name|
          value = send(attr_name)
          buffer[attr_name] = value if value
          buffer
        end
      end
    end
  end
end
