class User < ActiveRecord::Base

  belongs_to :father, class_name: "User"#, as: :child
  belongs_to :grandfather, class_name: "User", inverse_of: :grandsons

  has_many :sons, class_name: "User", foreign_key: :father_id
  has_many :grandsons, through: :sons
end
