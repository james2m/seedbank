class Party < ActiveRecord::Base

  has_many :states
  has_many :counties
  has_many :cities
end
