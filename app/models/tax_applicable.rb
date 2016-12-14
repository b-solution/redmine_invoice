class TaxApplicable < ActiveRecord::Base
  unloadable
  belongs_to :tax
end
