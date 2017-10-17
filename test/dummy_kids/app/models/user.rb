class User < ActiveRecord::Base

  has_many :children
  has_many :grand_children, through: :children
  has_many :great_grand_children, through: :grand_children

  belongs_to :father
  belongs_to :mother

  validates_presence_of :father
  validates_presence_of :mother

end
