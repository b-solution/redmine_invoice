class Invoice < ActiveRecord::Base
  unloadable

  belongs_to :project
  belongs_to :issue
  belongs_to :client

  has_many :invoice_taxes, dependent: :destroy
  has_many :invoice_issues, dependent: :destroy
  accepts_nested_attributes_for :invoice_issues, reject_if: :all_blank, allow_destroy: true



  include Redmine::SafeAttributes

  safe_attributes 'project_id',
                  'client_id',
                  'issue_contract_amount',
                  'tax_amount',
                  'invoice_amount',
                  'issue_ratio_done'

  validates_presence_of :project_id, :client_id,
                        :issue_contract_amount, :tax_amount,
                        :invoice_amount, :issue_ratio_done

  def editable?
    User.current.allowed_to_globally?(:manage_invoices)
  end

  def issues_titles
    invoice_issues.map(&:issue).map(&:subject).join('<br/>').html_safe
  end

  def deletable?
    User.current.allowed_to_globally?(:manage_invoices)
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
