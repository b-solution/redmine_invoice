class PaymentReceipt < ActiveRecord::Base
  unloadable

  belongs_to :invoice
  belongs_to :project

  include Redmine::SafeAttributes

  safe_attributes 'project_id',
                  'invoice_id',
                  'cheque_no',
                  'bank_name',
                  'date_on_cheque',
                  'cheque_amount',
                  'deductible_taxes',
                  'exp_cheque_amount'

  validates_presence_of :project_id, :invoice_id,
                        :cheque_no, :date_on_cheque,
                        :bank_name, :cheque_amount


  def self.invoice_for_fy
    if Date.today.month > 4
      where('created_at >= ?', Date.parse("01/04/#{Date.today.year}"))
    else
      where('created_at >= ?', Date.parse("01/04/#{Date.today.year - 1}"))
    end
  end

end
