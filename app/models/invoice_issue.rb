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

  def self.old_rate_for_issues(issue_id, id=nil)
    scope = where(issue_id: issue_id)
    scope = where.not(id: id) if id
    scope.sum(:rate)
  end

  def rate_for_issue
    issue_amount = issue.contract_amount.to_f
    self.issue_contract_amount = issue_amount
    (issue_amount * self.ratio_done) / 100
  end

  def old_rate
    return @old_rate if @old_rate
    @old_rate = InvoiceIssue.old_rate_for_issues(self.issue_id, self.id)
    @old_rate
  end

  def old_qty
    return  @old_qty if  @old_qty
    @old_qty = InvoiceIssue.where(issue_id: issue_id).where.not(id: id).sum(:ratio_done)
    @old_qty
  end

  def set_invoice_params(hash)
    self.ratio_done = hash[:ratio_done]
    self.rate = rate_for_issue
  end
end
