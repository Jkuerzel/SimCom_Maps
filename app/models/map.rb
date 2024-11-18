# == Schema Information
#
# Table name: maps
#
#  id                  :bigint           not null, primary key
#  executives_count    :integer
#  map_buildings_count :integer
#  name                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  owner_id            :integer
#
class Map < ApplicationRecord
  #Add Direct Associations
  belongs_to :owner, required: true, class_name: "User", foreign_key: "owner_id", counter_cache: true
  has_many  :comments, class_name: "Comment", foreign_key: "map_id", dependent: :destroy
  has_many  :likes, class_name: "Like", foreign_key: "map_id", dependent: :destroy
  has_many  :map_buildings, class_name: "MapBuilding", foreign_key: "map_id", dependent: :destroy
  has_many  :executives, class_name: "Executive", foreign_key: "map_id", dependent: :destroy
  #Add Indirect Associations
  has_many :building_types, through: :map_buildings, source: :building_type
  #Add Validations
  validates :owner_id, presence: true
  validates :name, presence: true
end
