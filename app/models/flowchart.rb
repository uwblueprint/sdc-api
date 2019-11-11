# frozen_string_literal: true

class Flowchart < ApplicationRecord
  def self.calculate_and_set_max_height(flowchart_id)
    flowchartnodes = FlowchartNode.where(flowchart_id: flowchart_id)
    nodes_indexed_by_id = {}
    root_node = FlowchartNode.get_root_node(flowchart_id)

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
