# frozen_string_literal: true

class FlowchartController < ApplicationController
  def create
    @flowchart = Flowchart.new(JSON.parse(request.body.read))

    unless @flowchart.valid?
      render status: 400, json: { error: 'Invalid Flowchart params' }
      return
    end

    @flowchart = Flowchart.create(JSON.parse(request.body.read))
    root_node = FlowchartNode.create(flowchart_id: @flowchart.id, text: 'New Node', header: 'Options', is_root: true, deleted: false)
    @flowchart[:root_id] = root_node.id
    @flowchart.save

    render json: @flowchart
  end

  def update
    flowchart = Flowchart.find_by(id: params[:id])
    unless flowchart
      render status: 404, json: { error: 'Could not find flowchart' }
      return
    end

    flowchart.update_attributes(JSON.parse(request.body.read))
    unless flowchart.valid?
      render status: 400, json: { error: 'Invalid flowchart params' }
      return
    end

    @flowchart = Flowchart.update(params[:id], JSON.parse(request.body.read))
    render json: @flowchart
  end

  def delete
    @flowchart = Flowchart.find_by(id: params[:id])
    unless @flowchart
      render status: 404, json: { error: 'Could not find flowchart' }
      return
    end

    Flowchart.find(params[:id]).update(deleted: true)
    FlowchartNode.where(flowchart_id: params[:id]).update_all(deleted: true)
    @flowchart[:deleted] = true

    render json: @flowchart
  end

  def all_flowcharts
    render json: Flowchart.where(deleted: false)
  end

  def serialized_flowchart_by_id
    flowchartnodes = FlowchartNode.where(flowchart_id: params[:id], deleted: false)
    flowchart = Flowchart.find_by(id: params[:id], deleted: false)

    unless flowchart
      render status: 404, json: { error: "No flowchart found with id #{params[:id]}." }
      return
    end

    root_node = FlowchartNode.find(flowchart.root_id)

    nodes_indexed_by_id = {}
    flowchartnodes.each do |node|
      nodes_indexed_by_id[node.id] = node
    end

    adjacency_list = {}
    if root_node

      queue = [root_node.id]
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

    end

    @serialized_flowchart = {}
    @serialized_flowchart[:flowchart] = flowchart
    @serialized_flowchart[:flowchartnodes] = nodes_indexed_by_id
    @serialized_flowchart[:adjacency_list] = adjacency_list
    render json: @serialized_flowchart
  end
end
