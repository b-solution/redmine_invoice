require_dependency 'project'
module  RedmineInvoice
  module ProjectPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        safe_attributes 'client_id', 'default_user_id', 'work_order_date', 'work_order_number', 'project_code'
        belongs_to :client
        belongs_to :default_user, class_name: 'User'
        has_many :invoices

        # validates_format_of :work_order_number, :with => /\A[A-Za-z0-9]+\Z/i
      end
    end
    module InstanceMethods

    end


  end
end
