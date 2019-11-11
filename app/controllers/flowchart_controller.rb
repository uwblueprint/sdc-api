# frozen_string_literal: true

class FlowchartController < ApplicationController
  def serialized_flowchart_by_id
    # TODO: Add Error Checking for invalid inputs or missing data in the database (eg. no flowchart with that id)
    flowchartnodes = FlowchartNode.where(flowchart_id: params[:id])
    flowchart = Flowchart.find(params[:id])
    root_node = FlowchartNode.get_root_node(params[:id])

    nodes_indexed_by_id = {}
    flowchartnodes.each do |node|
      nodes_indexed_by_id[node.id] = node
    end

    queue = [root_node.id]
    adjacency_list = {}
    visited = {}
    until queue.empty?
      current_node_id = queue.shift
      next if visited.key?(current_node_id)

      visited[current_node_id] = true
      current_node = nodes_indexed_by_id[current_node_id]

      unless adjacency_list.key?(current_node_id)
        adjacency_list[current_node_id] = {}
      end

      if current_node[:sibling_id]
        adjacency_list[current_node_id][:sibling_id] = current_node[:sibling_id]
        queue.push(current_node[:sibling_id])
      end

      if current_node[:child_id]
        adjacency_list[current_node_id][:child_id] = current_node[:child_id]
        queue.push(current_node[:child_id])
      end
    end

    @serialized_flowchart = {}
    @serialized_flowchart[:flowchart] = flowchart
    @serialized_flowchart[:flowchartnodes] = nodes_indexed_by_id
    @serialized_flowchart[:adjacency_list] = adjacency_list

    render json: @serialized_flowchart
  end
end
