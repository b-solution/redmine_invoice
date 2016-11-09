class PaymentReceipt < ActiveRecord::Base
  unloadable

  belongs_to :issue
  belongs_to :invoice
  belongs_to :project

  include Redmine::SafeAttributes

  safe_attributes 'project_id',
                  'issue_id',
                  'invoice_id',
                  'cheque_no',
                  'bank_name',
                  'date_on_cheque',
                  'cheque_amount'

  validates_presence_of :project_id, :issue_id, :invoice_id,
                        :cheque_no, :date_on_cheque,
                        :bank_name, :cheque_amount
end
