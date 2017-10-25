class State < ActiveRecord::Base

  belongs_to :party

  has_many :counties
  has_many :cities, through: :counties

  validates_presence_of :party
end
