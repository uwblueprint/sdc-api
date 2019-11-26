# frozen_string_literal: true

class FlowchartNode < ApplicationRecord
  belongs_to :flowchart
  validates :text, presence: true
  validates :header, presence: true
  validates :child_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :sibling_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :is_root, null: false
  validates :flowchart_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, null: false
  validates :deleted, inclusion: { in: [true, false] }

  def soft_delete
    self.deleted = true
    save
    sibling = FlowchartNode.find_by(id: sibling_id)
    child = FlowchartNode.find_by(id: child_id)
    sibling&.soft_delete
    child&.soft_delete
  end
end

