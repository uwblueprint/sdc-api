# frozen_string_literal: true

class FlowchartNode < ApplicationRecord
  belongs_to :flowchart
  validates :text, presence: true
  validates :header, presence: true
  validates :button_text, exclusion: { in: [''] }
  validates :next_question, exclusion: { in: [''] }
  validates :child_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :sibling_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :is_root, null: false
  validates :flowchart_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, null: false
  validates :deleted, inclusion: { in: [true, false] }

  def delete
    self.deleted = true 

    parent_node = FlowchartNode.find_by(child_id: self.id)
    left_node = FlowchartNode.find_by(sibling_id: self.id)
    child_node = FlowchartNode.find_by(id: self.child_id)

    if !parent_node && !left_node
      save!
    elsif !parent_node
      left_node.sibling_id = self.sibling_id
      ActiveRecord::Base.transaction do
        left_node.save!
        save!
      end
    else
      parent_node.child_id = self.sibling_id
      ActiveRecord::Base.transaction do
        parent_node.save!
        save!
      end
    end
    child_node&.child_delete
    return self
  end

  def child_delete
    self.deleted = true
    save!
    sibling = FlowchartNode.find_by(id: sibling_id)
    child = FlowchartNode.find_by(id: child_id)
    sibling&.child_delete
    child&.child_delete
  end
end

