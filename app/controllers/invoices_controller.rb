class InvoicesController < ApplicationController
  unloadable
  before_action :set_invoice, only: [:edit, :update, :destroy, :show]
  before_action :authorize_global

  helper :issues
  include IssuesHelper


  def index
    @invoices = Invoice.all
  end

  def show
    @issue = @invoice.issue
    @project = @invoice.project
    @client = @invoice.client
    @taxes = @invoice.invoice_taxes
  end

  def new
    @issue = Issue.find(params[:issue_id])
    @project = @issue.project
    @client = @project.client
    @invoice = Invoice.new(issue_id: @issue.id,
                           project_id: @project.id,
                           client_id: @client.try(:id)

    )
    if @issue.nil? or @issue.contract_amount.to_i.zero?
      flash[:error] = 'Issue Does not have an amount to make this invoice'
      redirect_to :back
    elsif @client.nil?
      flash[:error] = 'Client Does not exist'
      redirect_to :back
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def create
    invoice = Invoice.new
    invoice.safe_attributes = invoice_params
    reimb_tax = ReimbursementTax.active
    total_r_tax = reimb_tax.sum(:rate)
    deductible_tax = DeductibleTax.active
    total_deductible_tax = deductible_tax.sum(:rate)
    issue  = invoice.issue
    if issue.nil? or issue.contract_amount.to_f.zero?
      flash.now[:error] = 'Issue Does not have an amount to make this invoice'
      render :new && return
    else
      total_tax = total_r_tax - total_deductible_tax
      amount = (issue.contract_amount.to_f * invoice.issue_ratio_done) / 100

      invoice.original_amount = amount
      # Check older invoices
      old_invoices = Invoice.where(issue_id: invoice.issue_id)

      # substract the amounts
      amount = amount - old_invoices.sum(:issue_contract_amount)

      invoice.old_amount = old_invoices.sum(:issue_contract_amount)

      amount_with_tax = amount + (amount * (total_tax.to_f/100) )

      invoice.tax_amount = total_tax
      invoice.tax_amount = total_tax
      invoice.issue_contract_amount = amount
      invoice.invoice_amount = amount_with_tax

      if invoice.save
        deductible_tax.each do | tax|
          InvoiceTax.create(invoice_id: invoice.id, tax_id: tax.id, rate: -tax.rate)
        end

        reimb_tax.each do | tax|
          InvoiceTax.create(invoice_id: invoice.id, tax_id: tax.id, rate: tax.rate)
        end

        respond_to do |format|
          format.html { redirect_to invoice_path(invoice), notice: 'Invoice was successfully created.' }
        end

      else
        respond_to do |format|
          format.html { render :new }
        end
      end
    end
  end

  def edit

  end

  def update
    invoice.safe_attributes = invoice_params
    reimb_tax = ReimbursementTax.active
    total_r_tax = reimb_tax.sum(:rate)
    deductible_tax = DeductibleTax.active
    total_deductible_tax = deductible_tax.sum(:rate)
    issue  = invoice.issue
    if issue.nil? or issue.contract_amount.to_f.zero?
      flash.now[:error] = 'Issue Does not have an amount to make this invoice'
      render :new && return
    else
      total_tax = total_r_tax - total_deductible_tax
      amount = (issue.contract_amount.to_f * invoice.issue_ratio_done) / 100

      invoice.original_amount = amount
      # Check older invoices
      old_invoices = Invoice.where(issue_id: invoice.issue_id)

      # substract the amounts
      amount = amount - old_invoices.sum(:issue_contract_amount)

      invoice.old_amount = old_invoices.sum(:issue_contract_amount)

      amount_with_tax = amount + (amount * (total_tax.to_f/100) )

      invoice.tax_amount = total_tax
      invoice.tax_amount = total_tax
      invoice.issue_contract_amount = amount
      invoice.invoice_amount = amount_with_tax

      if invoice.save
        respond_to do |format|
          format.html { redirect_to invoice_path(invoice), notice: 'Invoice was successfully created.' }
        end

      else
        respond_to do |format|
          format.html { render :edit }
        end
      end
    end
  end

  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html {
        flash[:notice] = 'Invoice was successfully destroyed.'
        redirect_to invoices_path
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
