class PaymentsController < ApplicationController
  unloadable
  before_action :set_payment, only: [:edit, :update, :destroy, :show]
  before_action :authorize_global

  helper :issues
  include IssuesHelper


  def index
    @payments = PaymentReciept.all
  end

  def show

  end


  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  def destroy
    @payment.destroy
    respond_to do |format|
      format.html {
        flash[:notice] = 'Invoice was successfully destroyed.'
        redirect_to payments_path
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
