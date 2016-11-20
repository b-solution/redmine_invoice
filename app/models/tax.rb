class Tax < ActiveRecord::Base
  unloadable

  include Redmine::SafeAttributes

  include Redmine::SubclassFactory

  safe_attributes 'name', 'rate', 'applicable_from', 'type'

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
    visible.where("applicable_from <= ?", Date.today)
  end

  def self.visible
    where(active: true)
  end

end

require_dependency 'reimbursement_tax'
require_dependency 'deductible_tax'
