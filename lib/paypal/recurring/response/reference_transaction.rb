module PayPal
  module Recurring
    module Response
      class ReferenceTransaction < Base
        mapping(:reference_id     => :BILLINGAGREEMENTID,
                :description      => :DESC,
                :amount           => :AMT,
                :currency         => :CURRENCYCODE,
                :transaction_id   => :TRANSACTIONID,
                :fee_amt          => :FEEAMT,
                :payment_status   => :PAYMENTSTATUS,
                :payment_type     => :PAYMENTTYPE,
                :transaction_type => :TRANSACTIONTYPE)
      end
    end
  end
end
