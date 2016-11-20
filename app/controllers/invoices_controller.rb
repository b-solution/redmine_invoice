class InvoicesController < ApplicationController
  unloadable
  before_action :set_invoice, only: [:edit, :update, :destroy, :show]
  before_action :authorize_global
  before_action :find_project_by_project_id

  helper :issues
  include IssuesHelper


  def index
    @invoices = @project.invoices
  end

  def show
    @issue = @invoice.issue
    @project = @invoice.project
    @client = @invoice.client
    @taxes = @invoice.invoice_taxes
  end

  def new
    @client = @project.client
    @invoice = Invoice.new(project_id: @project.id,
                           client_id: @client.try(:id)

    )
    @invoice.invoice_issues.build
    if @client.nil?
      flash[:error] = 'Client Does not exist'
      redirect_to :back
    end
  end

  ##
  # Issue 1 => 1000 $
  # Issue 2 => 100 $
  # Issue 3 => 200 $
  #
  # #


  #  INVOICE 1 (RATION : 20%) FOR ISSUE 1, 2 & 3
  #  OLD ISSUE SUM = 0$
  # Issue 1 => 200 $
  # Issue 2 => 20 $
  # Issue 3 => 40 $
  # TOTAL => 260 $
  # #


  #  INVOICE 1 (RATION : 50%) FOR ISSUE 1, 2 & 3
  #  OLD ISSUE SUM = 260$
  # Issue 1 => 500 - 200 $
  # Issue 2 => 50 - 20 $
  # Issue 3 => 100 - 40 $
  # TOTAL =>390 $
  # #
  def create
    @invoice = Invoice.new
    @invoice.safe_attributes = invoice_params
    reimb_tax = ReimbursementTax.active
    total_r_tax = reimb_tax.sum(:rate)
    deductible_tax = DeductibleTax.active
    total_deductible_tax = deductible_tax.sum(:rate)

    issues_invoice_params = params[:invoice][:invoice_issues_attributes]
    valid_issues = []
    invalid_issues = []
    issues_invoice_params.each do |k, hash|
      i = Issue.where(id: hash[:issue_id]).first if hash[:issue_id].present?
      if i and i.contract_amount.to_f > 0
        valid_issues << i
      elsif i
        invalid_issues << i
      end
    end

    if invalid_issues.present?
      flash.now[:error] =  "These Ids does not have contract amount [#{invalid_issues.map(&:id)}]"
      render(:template => 'invoices/new', :layout => !request.xhr?) && return
    end
    c = InvoiceIssue.where(issue_id: valid_issues.map(&:id)).
        where('ratio_done > ?', @invoice.issue_ratio_done.to_i ).
        pluck(:issue_id)
    if c.present?
      flash.now[:error] = "These Ids ([#{c.join(', ')}]= does have invoice with rate > than #{@invoice.issue_ratio_done.to_i}"
      respond_to do |format|
        format.html {
          render(:template => 'invoices/new', :layout => !request.xhr?) && return
        }
      end
    end

    total_tax = total_r_tax - total_deductible_tax

    #
    # We do have these params
    # @invoice.project_id
    # @invoice.client_id
    # @invoice.issue_ratio_done
    # #

    invoice_issues = []
    #save Invoice issue
    valid_issues.each do |issue|
      invoice_issue = InvoiceIssue.new(issue_id: issue.id)
      invoice_issue.set_invoice_params(@invoice)
      invoice_issues<< invoice_issue
    end

    @invoice.original_amount = valid_issues.map(&:contract_amount).sum * (@invoice.issue_ratio_done.to_f / 100)
    @invoice.issue_contract_amount = invoice_issues.sum(&:rate)

    @invoice.old_amount = @invoice.original_amount - @invoice.issue_contract_amount

    @invoice.tax_amount = @invoice.issue_contract_amount * (total_tax.to_f/100)

    @invoice.invoice_amount = @invoice.issue_contract_amount + @invoice.tax_amount


    if @invoice.save
      deductible_tax.each do | tax|
        InvoiceTax.create(invoice_id: @invoice.id, tax_id: tax.id, rate: -tax.rate)
      end

      reimb_tax.each do | tax|
        InvoiceTax.create(invoice_id: @invoice.id, tax_id: tax.id, rate: tax.rate)
      end

      invoice_issues.each do |v|
        v.invoice_id = @invoice.id
        v.save
      end

      respond_to do |format|
        format.html { redirect_to project_invoice_path(@project, @invoice), notice: 'Invoice was successfully created.' }
      end

    else
      respond_to do |format|
        format.html { render :new }
      end
    end


  end

  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html {
        flash[:notice] = 'Invoice was successfully destroyed.'
        redirect_to project_invoices_path(@project)
      }
      format.json { head :no_content }
    end
  end


  private

  def set_invoice
    @invoice  = Invoice.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def invoice_params
    params.require(:invoice).permit!
  end
end
