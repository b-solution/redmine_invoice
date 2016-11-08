class Client < ActiveRecord::Base
  unloadable

  include Redmine::SafeAttributes

  safe_attributes 'name', 'home_address', 'phone', 'email'

  validates_presence_of :name, :email

  def editable?
    User.current.allowed_to_globally?(:edit_client)
  end

  def deletable?
    User.current.allowed_to_globally?(:delete_client)
  end

  def address
    home_address
  end

  def self.visible
    where(active: true)
  end

  def to_s
    name
  end
end
