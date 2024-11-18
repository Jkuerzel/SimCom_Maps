# == Schema Information
#
# Table name: resources
#
#  id                       :bigint           not null, primary key
#  name                     :string
#  production_time_per_unit :time
#  transport_amount         :float
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  building_id              :integer
#
class Resource < ApplicationRecord
  #Add Direct Associations
  belongs_to :building, required: true, class_name: "Building", foreign_key: "building_id"
  has_many  :prices, class_name: "Price", foreign_key: "resource_id", dependent: :destroy
  has_many  :productionruns, class_name: "Productionrun", foreign_key: "product_id", dependent: :destroy
  has_many  :dependant_resources, class_name: "Resourcedependency", foreign_key: "product_id", dependent: :destroy
  has_many  :input_relationships, class_name: "Resourcedependency", foreign_key: "input_id", dependent: :destroy
  #Add Indirect Associations
  has_many :inputs, through: :dependant_resources, source: :input
  has_many :products, through: :input_relationships, source: :product
  #Add Validations
  validates :transport_amount, numericality: { greater_than_or_equal_to: 0 }
end
