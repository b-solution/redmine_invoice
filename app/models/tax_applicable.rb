class TaxApplicable < ActiveRecord::Base
  unloadable
  belongs_to :tax
  validates_numericality_of :rate, greater_than: 0
  validates_presence_of :rate, :applicable_from
end
