class City < ActiveRecord::Base

  belongs_to :county
  delegate :state, :to => :county, :allow_nil => true
end
