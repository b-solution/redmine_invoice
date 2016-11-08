class InvoiceTax < ActiveRecord::Base
  unloadable
  belongs_to :invoice
  belongs_to :tax
end
