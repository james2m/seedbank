class County < ActiveRecord::Base

  belongs_to :state
  has_many :cities

  validates_presence_of :state
end
