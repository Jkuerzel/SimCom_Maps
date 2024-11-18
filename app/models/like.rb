# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  map_id     :integer
#  user_id    :integer
#
class Like < ApplicationRecord
  #Add Direct Associations
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id", counter_cache: true
  belongs_to :map, required: true, class_name: "Map", foreign_key: "map_id"
  #Add Indirect Associations
  #Add Validations
  validates :user_id, presence: true
  validates :map_id, presence: true
end
