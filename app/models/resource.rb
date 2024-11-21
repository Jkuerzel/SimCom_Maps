# == Schema Information
#
# Table name: resources
#
#  id               :bigint           not null, primary key
#  image_link       :string
#  name             :string
#  transport_amount :float
#  units_per_hour   :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  building_id      :integer
#
class Resource < ApplicationRecord
  #Add Direct Associations
  belongs_to :building, required: true, class_name: "Building", foreign_key: "building_id"
  has_many  :prices, class_name: "Price", foreign_key: "resource_id", dependent: :destroy
  has_many  :map_buildings, class_name: "MapBuilding", foreign_key: "building_id", dependent: :nullify
  has_many  :dependant_resources, class_name: "Resourcedependency", foreign_key: "product_id", dependent: :destroy
  has_many  :input_relationships, class_name: "Resourcedependency", foreign_key: "input_id", dependent: :destroy
  #Add Indirect Associations
  has_many :inputs, through: :dependant_resources, source: :input
  has_many :products, through: :input_relationships, source: :product
  #Add Validations
  validates :transport_amount, numericality: { greater_than_or_equal_to: 0 }

  def price_for_quality(level)
    self.prices.where(:quality_level=> level).first.price
  end
end
