class PaymentsController < ApplicationController
  unloadable
  before_action :set_payment, only: [:edit, :update, :destroy, :show]
  before_action :authorize_global
  before_action :find_project_by_project_id

  helper :issues
  include IssuesHelper


  def index
    if params[:invoice_id]
      @payments = PaymentReceipt.where(invoice_id: params[:invoice_id] )
    else
      @payments = PaymentReceipt.all
    end
  end

  def show

  end


  def new
    @payment = PaymentReceipt.new(invoice_id: params[:invoice_id])
    i = Invoice.find(params[:invoice_id])
    @payment.project_id = i.project_id
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def create
    @payment = PaymentReceipt.new
    @payment.safe_attributes = payment_params
    last_d_tax = DeductibleTax.active.last
    d_tax = last_d_tax ? last_d_tax.rate : 0
    @payment.deductible_taxes = d_tax
    if @payment.save
      respond_to do |format|
        format.html { redirect_to project_payment_path(@project, @payment), notice: 'Payment was successfully created.' }
      end

    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end

  def edit

  end

  def update
    @payment.safe_attributes = payment_params
    if @payment.save
      respond_to do |format|
        format.html { redirect_to project_payment_path(@project, @payment), notice: 'Payment was successfully updated.' }
      end

    else
      respond_to do |format|
        format.html { render :edit }
      end
    end
  end

  def destroy
    invoice = @payment.invoice
    @payment.destroy
    respond_to do |format|
      format.html {
        flash[:notice] = 'Payment was successfully destroyed.'
        redirect_to project_payments_path(@project, invoice_id: invoice.id)
      }
      format.json { head :no_content }
    end
  end


  private

  def set_payment
    @payment  = PaymentReceipt.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def payment_params
    params.require(:payment).permit!
  end
end
