# frozen_string_literal: true

class FlowchartNodeController < ApplicationController
  def create
    prev_id = params[:prev_id]
    is_child = params[:is_child]

    prev_node = FlowchartNode.find(prev_id)

    new_node = FlowchartNode.new(params[:node].permit(:text, :header, :button_text, :next_question))
    new_node.is_root = false
    new_node.flowchart_id = prev_node.flowchart_id

    ActiveRecord::Base.transaction do
      new_node.save!
      if is_child == 'true'
        new_node.child_id = prev_node.child_id
        prev_node.child_id = new_node.id
      else
        new_node.sibling_id = prev_node.sibling_id
        prev_node.sibling_id = new_node.id
      end
      new_node.save!
      prev_node.save!
    end
    render json: new_node
  end

  def show
    node = FlowchartNode.find(params[:id])
    render json: node
  end

  def update
    flowchart_node = FlowchartNode.find(params[:id])
    flowchart_node.update!(params[:node].permit(:text, :header, :button_text, :next_question))
    render json: flowchart_node
  end

  def swap
    node_a = FlowchartNode.find(params[:id_a])
    node_b = FlowchartNode.find(params[:id_b])

    node_a.text, node_b.text = node_b.text, node_a.text
    node_a.header, node_b.header = node_b.header, node_a.header
    node_a.button_text, node_b.button_text = node_b.button_text, node_a.button_text
    node_a.next_question, node_b.next_question = node_b.next_question, node_a.next_question
    node_a.is_root, node_b.is_root = node_b.is_root, node_a.is_root
    node_a.child_id, node_b.child_id = node_b.child_id, node_a.child_id
    ActiveRecord::Base.transaction do
      node_a.save!
      node_b.save!
    end
    render json: { new_a: node_a, new_b: node_b }
  end

  def delete
    delete_node = FlowchartNode.find(params[:id])
    delete_node&.delete
    render json: delete_node
  end
end
