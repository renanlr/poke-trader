class Pokemon < ApplicationRecord
  belongs_to :trade

  validates :name, :base_experience, :trade_group, presence: true

  scope :from_group_a, -> { where(trade_group: 1) }
  scope :from_group_b, -> { where(trade_group: 2) }
end
