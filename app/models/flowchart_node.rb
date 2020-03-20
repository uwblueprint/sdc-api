# frozen_string_literal: true

# == Schema Information
#
# Table name: flowchart_nodes
#
#  id                :bigint           not null, primary key
#  button_text       :string
#  deleted           :boolean          default(FALSE), not null
#  header            :string           not null
#  is_leaf           :boolean          default(FALSE), not null
#  is_root           :boolean          not null
#  next_question     :string
#  text              :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  child_id          :bigint
#  flowchart_id      :bigint           not null
#  flowchart_node_id :bigint
#  sibling_id        :bigint
#
# Indexes
#
#  index_flowchart_nodes_on_child_id           (child_id)
#  index_flowchart_nodes_on_flowchart_id       (flowchart_id)
#  index_flowchart_nodes_on_flowchart_node_id  (flowchart_node_id)
#  index_flowchart_nodes_on_sibling_id         (sibling_id)
#
# Foreign Keys
#
#  fk_rails_...  (child_id => flowchart_nodes.id)
#  fk_rails_...  (flowchart_id => flowcharts.id)
#  fk_rails_...  (flowchart_node_id => flowchart_nodes.id)
#  fk_rails_...  (sibling_id => flowchart_nodes.id)
#

class FlowchartNode < ApplicationRecord
  belongs_to :flowchart
  belongs_to :parent, class_name: 'FlowchartNode', optional: true
  has_many :flowchart_icon_helpers
  has_many :flowchart_icons, through: :flowchart_icon_helpers
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

  def children
    FlowchartNode.where(flowchart_node_id: id).find_each
  end
end
