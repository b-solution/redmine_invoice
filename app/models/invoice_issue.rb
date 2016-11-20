class InvoiceIssue < ActiveRecord::Base
  unloadable
  belongs_to :issue
  belongs_to :invoice

  include Redmine::SafeAttributes

  safe_attributes 'issue_id',
                  'invoice_id',
                  'rate',
                  'issue_contract_amount',
                  'ratio_done'

  def self.rate_for_issues(issue_id)
    where(issue_id: issue_id).sum(:rate)
  end

  def rate_for_issue
    issue_amount = issue.contract_amount.to_f
    self.issue_contract_amount = issue_amount
    r = (issue_amount * self.ratio_done) / 100
    older_rate= InvoiceIssue.rate_for_issues(self.issue_id)
    r.to_f - older_rate.to_f
  end

  def set_invoice_params(invoice)
    self.invoice_id = invoice.id
    self.ratio_done = invoice.issue_ratio_done
    self.rate = rate_for_issue
  end
end
