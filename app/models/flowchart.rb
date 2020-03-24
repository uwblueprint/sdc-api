# frozen_string_literal: true

# == Schema Information
#
# Table name: flowcharts
#
#  id          :bigint           not null, primary key
#  deleted     :boolean          default(FALSE), not null
#  description :string           not null
#  height      :integer          not null
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  root_id     :bigint
#
# Indexes
#
#  index_flowcharts_on_root_id  (root_id)
#
# Foreign Keys
#
#  fk_rails_...  (root_id => flowchart_nodes.id)
#

class Flowchart < ApplicationRecord
  has_many :flowchart_nodes
  # attr_accessible :flowchart_nodes_attributes
  accepts_nested_attributes_for :flowchart_nodes, :allow_destroy => true
  validates :title, presence: true
  validates :description, presence: true
  # validates :height, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true
  validates :root_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :deleted, inclusion: { in: [true, false] }, allow_nil: true # defaults to false

  def calculate_and_set_max_height
    flowchartnodes = FlowchartNode.where(flowchart_id: id, deleted: false)
    nodes_indexed_by_id = {}
    root_node = FlowchartNode.find(root_id)
    if root_node.nil?
      update(height: 0)
      return
    end

    flowchartnodes.each do |node|
      nodes_indexed_by_id[node.id] = node
    end

    visited = {}
    queue = [[root_node.id, 0]]
    max_height = 0
    until queue.empty?
      current = queue.shift
      current_node_id = current[0]
      current_height = current[1]
      next if visited.key?(current_node_id)

      visited[current_node_id] = true
      current_node = nodes_indexed_by_id[current_node_id]

      max_height = [max_height, current_height].max

      if current_node[:child_id]
        queue.push([current_node[:child_id], current_height + 1])
      end
    end

    update(height: max_height)
  end

  def serialized
    root_node = FlowchartNode.find(root_id)
    flowchartnodes = FlowchartNode.where(flowchart_id: id, deleted: false)

    nodes_indexed_by_id = {}
    flowchartnodes.each do |node|
      nodes_indexed_by_id[node.id] = node
    end

    adjacency_list = {}
    if root_node
      queue = [root_node.id]
      until queue.empty?
        current_node_id = queue.shift
        current_node = nodes_indexed_by_id[current_node_id]

        if current_node[:child_id].nil?
          adjacency_list[current_node_id] = []
        else
          adjacents = []
          traverse_id = current_node[:child_id]
          until traverse_id.nil?
            adjacents.push(traverse_id)
            queue.push(traverse_id)
            traverse = nodes_indexed_by_id[traverse_id]
            traverse_id = traverse[:sibling_id]
          end
          adjacency_list[current_node_id] = adjacents
        end
      end
    end

    @serialized_flowchart = {}
    @serialized_flowchart[:flowchart] = attributes
    @serialized_flowchart[:flowchartnodes] = nodes_indexed_by_id
    @serialized_flowchart[:adjacency_list] = adjacency_list
    @serialized_flowchart
  end
end
