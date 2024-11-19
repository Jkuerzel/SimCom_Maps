# == Schema Information
#
# Table name: prices
#
#  id            :bigint           not null, primary key
#  price         :float
#  quality_level :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resource_id   :integer
#
class Price < ApplicationRecord
  #Add Direct Associations
  belongs_to :resource_quality_level, required: true, class_name: "Resource", foreign_key: "resource_id"
  #Add Indirect Associations
  has_one  :production_building, through: :resource_quality_level, source: :production_buildings
  #Add Validations
  validates :price, presence: true
end
