# == Schema Information
#
# Table name: resourcedependencies
#
#  id                :bigint           not null, primary key
#  quantity_required :float
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  input_id          :integer
#  product_id        :integer
#
class Resourcedependency < ApplicationRecord
  #Add Direct Associations
  belongs_to :product, required: true, class_name: "Resource", foreign_key: "product_id"
  belongs_to :input, required: true, class_name: "Resource", foreign_key: "input_id"
  #Add Indirect Associations
  #Add Validations
  validates :quantity_required, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity_required, presence: true
  validates :input_id, numericality: true
  validates :input_id, presence: true
end
