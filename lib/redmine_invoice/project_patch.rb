require_dependency 'project'
module  RedmineInvoice
  module ProjectPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        safe_attributes 'client_id', 'work_order_date', 'work_order_number'
        belongs_to :client
        has_many :invoices
      end
    end
    module InstanceMethods

    end


  end
end
