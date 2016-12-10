require_dependency 'issue'
module  RedmineInvoice
  module IssuePatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        safe_attributes 'contract_amount', 'item_number'
      end
    end
    module InstanceMethods

    end


  end
end
