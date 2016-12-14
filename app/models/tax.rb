class Tax < ActiveRecord::Base
  unloadable

  include Redmine::SafeAttributes

  include Redmine::SubclassFactory

  has_many :tax_applicables
  accepts_nested_attributes_for :tax_applicables, reject_if: :all_blank, allow_destroy: true


  safe_attributes 'name', 'type', 'tax_applicables_attributes'

  validates_presence_of :name, :rate, :type, :applicable_from
  validates_numericality_of :rate, greater_than: 0

  def self.get_classes_name
    subclasses.map(&:to_s)
  end



  def editable?
    User.current.admin?
  end

  def deletable?
    User.current.admin?
  end

  def self.active
    visible.includes(:tax_applicables).references(:tax_applicables).
        where("tax_applicables.applicable_from <= ?", Date.today)
  end


  def tax_applicable
    tax_applicables.where("applicable_from <= ?", Date.today).
        order("tax_applicables.applicable_from DESC").first
  end

  def self.visible
    where(active: true)
  end

end

require_dependency 'reimbursement_tax'
require_dependency 'deductible_tax'
