class County < ActiveRecord::Base

  belongs_to :state
  has_many :cities
end
