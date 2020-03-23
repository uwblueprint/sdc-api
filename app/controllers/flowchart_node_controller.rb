# frozen_string_literal: true

class FlowchartNodeController < ApplicationController
  def create
    prev_id = params[:prev_id]
    prev_node = FlowchartNode.find(prev_id)

    new_node = FlowchartNode.new(params[:node].permit(:text, :header, :button_text, :next_question))
    new_node.is_root = false
    new_node.flowchart_id = prev_node.flowchart_id

    ActiveRecord::Base.transaction do
      new_node.flowchart_node_id = prev_node.id
      new_node.save!
    end
    render json: new_node
  end

  def show
    node = FlowchartNode.find(params[:id])
    icons = node.flowchart_icons
    render json: { node: node, icons: icons }
  end

  def parent
    node = FlowchartNode.find(params[:id])
    parent_node = FlowchartNode.find_by(id: node.flowchart_node_id)
    render json: parent_node
  end

  def parents
    node = FlowchartNode.find(params[:id])
    if node.is_root
      render json: []
    else
      ary = [node]
      parent_node = FlowchartNode.find(node.flowchart_node_id)
      until parent_node.is_root
        ary.unshift(parent_node)
        node = parent_node
        parent_node = FlowchartNode.find(node.flowchart_node_id)
      end
      render json: ary
    end
  end

  def children
    node = FlowchartNode.find(params[:id])
    node_children = node.children
    render json: node_children
  end

  def update
    flowchart_node = FlowchartNode.find(params[:id])
    flowchart_node.update!(params[:node].permit(:text, :header, :button_text, :next_question))
    render json: flowchart_node
  end

  def swap
    node_a = FlowchartNode.find(params[:id_a])
    res = node_a&.swap(params[:id_b])

    render json: { new_a: res[:new_a], new_b: res[:new_b] }
  end

  def delete
    delete_node = FlowchartNode.find(params[:id])
    delete_node&.delete
    render json: delete_node
  end
end
