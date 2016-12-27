class Invoice < ActiveRecord::Base
  unloadable

  belongs_to :project
  belongs_to :issue
  belongs_to :client

  has_many :invoice_taxes, dependent: :destroy
  has_many :invoice_issues, dependent: :destroy
  has_many :payment_receipts, dependent: :destroy
  accepts_nested_attributes_for :invoice_issues, reject_if: :all_blank, allow_destroy: true



  include Redmine::SafeAttributes

  safe_attributes 'project_id',
                  'client_id',
                  'issue_contract_amount',
                  'tax_amount',
                  'invoice_amount'

  validates_presence_of :project_id, :client_id,
                        :issue_contract_amount, :tax_amount,
                        :invoice_amount

  def editable?
    User.current.allowed_to_globally?(:manage_invoices)
  end

  def issues_titles
    invoice_issues.map(&:issue).map(&:subject).join('<br/>').html_safe
  end

  def self.invoice_for_fy
    if Date.today.month > 4
      where('created_at >= ?', Date.parse("01/04/#{Date.today.year}"))
    else
      where('created_at >= ?', Date.parse("01/04/#{Date.today.year - 1}"))
    end
  end

  def estimate_deductible_tax
    invoice_base_amount =  self.issue_contract_amount
    last_d_tax = DeductibleTax.active.map{|t| t.tax_applicable }
    d_tax = last_d_tax ? last_d_tax.map{|t| t.rate }.sum : 0
    (d_tax * invoice_base_amount).to_f / 100
  end

  def tds
    payment = self.payment_receipts.first || PaymentReceipt.new
    ((payment.deductible_taxes.to_f * self.issue_contract_amount.round(2)).to_f / 100 ).round(2)
  end

  def deletable?
    User.current.allowed_to_globally?(:manage_invoices) and payment_receipts.empty?
  end

  def viewable?
    User.current.allowed_to_globally?(:view_invoices)
  end

  def deducted_tax
    invoice_taxes.where('rate < 0').sum(:rate)
  end

  def reimbursed_tax
    invoice_taxes.where('rate > 0').sum(:rate)
  end
end
