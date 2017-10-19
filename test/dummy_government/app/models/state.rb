class State < ActiveRecord::Base

  has_many :counties
  has_many :cities, through: :counties
end
