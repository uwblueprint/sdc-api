# frozen_string_literal: true

class FlowchartNodeController < ApplicationController
  def create
    prev_id = params[:prev_id]
    is_child = params[:is_child]
    begin
      prev_node = FlowchartNode.find(prev_id)
    rescue ActiveRecord::RecordNotFound
      render status: 404, json: { error: "No node found with id #{prev_id}." }
    else
      ActiveRecord::Base.transaction do
        @new_node = FlowchartNode.create(
          text: params[:text],
          header: params[:header],
          button_text: params[:button_text],
          next_question: params[:next_question],
          is_root: false,
          flowchart_id: prev_node.flowchart_id,
        )
        if is_child == 'true'
          @new_node.child_id = prev_node.child_id
          prev_node.child_id = @new_node.id
        else
          @new_node.sibling_id = prev_node.sibling_id
          prev_node.sibling_id = @new_node.id
        end
        @new_node.save!
        prev_node.save!
      end
      render json: @new_node.as_json
    end
  end

  def show
    id = params[:id]
    begin
      node = FlowchartNode.find(id)
    rescue ActiveRecord::RecordNotFound
      render status: 404, json: { error: "No node found with id #{id}." }
    else
      render json: node.as_json
    end
  end

  def update
    id = params[:id]
    begin
      flowchart_node = FlowchartNode.update(
        id,
        text: params[:text],
        header: params[:header],
        button_text: params[:button_text],
        next_question: params[:next_question]
      )
    rescue StandardError
      render status: 404, json: { error: "No node found with id #{id}." }
    else
      render json: flowchart_node.as_json
    end
  end

  def swap
    id_a = params[:id_a]
    id_b = params[:id_b]
    begin
      node_a = FlowchartNode.find(id_a)
      node_b = FlowchartNode.find(id_b)
    rescue ActiveRecord::RecordNotFound
      render status: 404, json: { error: 'Error finding nodes with the given ids.' }
    else
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
      render status: 200, json: { new_a: node_a.as_json, new_b: node_b.as_json }
    end
  end

  def delete
    delete_id = params[:id]
    begin
      delete_node = FlowchartNode.find(delete_id)
    rescue ActiveRecord::RecordNotFound
      render status: 404, json: { error: "No node found with id #{delete_id}." }
    else
      parent_node = FlowchartNode.find_by(child_id: delete_id)
      left_node = FlowchartNode.find_by(sibling_id: delete_id)
      child_node = FlowchartNode.find_by(id: delete_node.child_id)
      delete_node.deleted = true
      if !parent_node && !left_node
        delete_node.save!
      elsif !parent_node
        left_node.sibling_id = delete_node.sibling_id
        ActiveRecord::Base.transaction do
          left_node.save!
          delete_node.save!
        end
      else
        parent_node.child_id = delete_node.sibling_id
        ActiveRecord::Base.transaction do
          parent_node.save!
          delete_node.save!
        end
      end
      child_node&.soft_delete
      render status: 200, json: delete_node.as_json
    end
  end
end
