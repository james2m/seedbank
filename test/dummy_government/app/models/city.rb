class City < ActiveRecord::Base

  belongs_to :party
  belongs_to :county
  delegate :state, :to => :county, :allow_nil => true

  validates_presence_of :county
  validates_presence_of :party
end
