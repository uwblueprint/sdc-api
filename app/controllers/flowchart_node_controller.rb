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
    res = node_a&.swap(params[:id_b])

    render json: { new_a: res[:new_a], new_b: res[:new_b] }
  end

  def delete
    delete_node = FlowchartNode.find(params[:id])
    delete_node&.delete
    render json: delete_node
  end

end
