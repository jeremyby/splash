class Contact < ActiveRecord::Base
  validates_presence_of :email
  validates_uniqueness_of :email
end