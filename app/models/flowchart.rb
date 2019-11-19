# frozen_string_literal: true

class Flowchart < ApplicationRecord
  validates :title, format: { with: /[a-zA-Z ]/ }, null: false
  validates :description, format: { with: /[a-zA-Z ]/ }, null: false
  validates :height, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, null: false
  validates :deleted, inclusion: { in: [true, false] }, null: false

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
end
