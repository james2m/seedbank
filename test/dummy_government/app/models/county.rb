class County < ActiveRecord::Base

  belongs_to :state
  belongs_to :party
  has_many :cities

  validates_presence_of :state
  validates_presence_of :party
end
