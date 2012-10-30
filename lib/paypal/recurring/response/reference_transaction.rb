module PayPal
  module Recurring
    module Response
      class ReferenceTransaction < Base
        mapping(:reference_id => :REFERENCEID,
                :description  => :DESC,
                :amount       => :AMT,
                :currency     => :CURRENCYCODE)
      end
    end
  end
end
