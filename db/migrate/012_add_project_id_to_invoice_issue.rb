class AddProjectIdToInvoiceIssue < ActiveRecord::Migration
  def change
    add_column :invoice_issues, :project_id, :integer
    InvoiceIssue.all.each do |ii|
      ii.project_id = ii.issue.project_id
      ii.save
    end
  end
end
