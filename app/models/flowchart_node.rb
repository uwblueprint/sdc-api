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

  def swap(swap_id)
    node_b = FlowchartNode.find(swap_id)

    self.text, node_b.text = node_b.text, text
    self.header, node_b.header = node_b.header, header
    self.button_text, node_b.button_text = node_b.button_text, button_text
    self.next_question, node_b.next_question = node_b.next_question, next_question
    self.is_root, node_b.is_root = node_b.is_root, is_root
    self.child_id, node_b.child_id = node_b.child_id, child_id
    ActiveRecord::Base.transaction do
      save!
      node_b.save!
    end

    { new_a: self, new_b: node_b }
  end

  def delete
    self.deleted = true

    parent_node = FlowchartNode.find_by(child_id: id)
    left_node = FlowchartNode.find_by(sibling_id: id)
    child_node = FlowchartNode.find_by(id: child_id)

    if !parent_node && !left_node
      save!
    elsif !parent_node
      left_node.sibling_id = sibling_id
      ActiveRecord::Base.transaction do
        left_node.save!
        save!
      end
    else
      parent_node.child_id = sibling_id
      ActiveRecord::Base.transaction do
        parent_node.save!
        save!
      end
    end
    child_node&.child_delete
    self
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
