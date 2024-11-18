# == Schema Information
#
# Table name: executives
#
#  id               :bigint           not null, primary key
#  finance_level    :integer
#  marketing_level  :integer
#  name             :integer
#  operations_level :integer
#  position         :integer
#  research_level   :integer
#  salary           :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  map_id           :integer
#
class Executive < ApplicationRecord
  #Add Direct Associations
  belongs_to :map, required: true, class_name: "Map", foreign_key: "map_id", counter_cache: true
  #Add Indirect Associations
  #Add Validations
  validates :salary, presence: true
  validates :research_level, presence: true
  validates :position, presence: true
  validates :operations_level, presence: true
  validates :marketing_level, presence: true
  validates :finance_level, presence: true
end
