class City < ActiveRecord::Base

  belongs_to :county
  delegate :state, :to => :county, :allow_nil => true

  validates_presence_of :county
end
