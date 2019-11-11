class FlowchartNodeController < ApplicationController
  def show
    id = params[:id]
    node = FlowchartNode.find_by(id: id)
    if !node
      render status: 404, json: { error: "No node found with id #{id}." }
    else
      render json: node.as_json
    end
  end

  def update
    id = params[:id]
    text = params[:text]
    header = params[:header]
    button_text = params[:button_text]
    next_question = params[:next_question]
    node = FlowchartNode.find_by(id: id)
    if !node
      render status: 404, json: { error: "No node found with id #{id}." }
    else
      node[:text] = params[:text]
      node[:header] = params[:header]
      node[:button_text] = params[:button_text]
      node[:next_question] = params[:next_question]
      node.save!()
      render status: 200, json: node.as_json
    end
  end

  def swap
    # check for same level?
    id_a = params[:id_a]
    id_b = params[:id_b]
    node_a = FlowchartNode.find_by(id: id_a)
    node_b = FlowchartNode.find_by(id: id_b)
    if !node_a || !node_b
      render status: 404, json: { error: "Error finding nodes with the given ids." }
    else
      node_a[:text], node_b[:text] = node_b[:text], node_a[:text]
      node_a[:header], node_b[:header] = node_b[:header], node_a[:header]
      node_a[:button_text], node_b[:button_text] = node_b[:button_text], node_a[:button_text]
      node_a[:next_question], node_b[:next_question] = node_b[:next_question], node_a[:next_question]
      node_a[:is_root], node_b[:is_root] = node_b[:is_root], node_a[:is_root]
      node_a[:child_id], node_b[:child_id] = node_b[:child_id], node_a[:child_id]
      ActiveRecord::Base.transaction do
        node_a.save!()
        node_b.save!()
      end
    end
    render status: 200, json: { new_a: node_b.as_json, new_b: node_a.as_json }
  end

  def delete
    delete_id = params[:id]
    parent_node = FlowchartNode.find_by(child_id: delete_id)
    left_node = FlowchartNode.find_by(sibling_id: delete_id)
    delete_node = FlowchartNode.find_by(id: delete_id)
    if !parent_node && !left_node
      delete_node.delete()
    elsif !parent_node
      left_node[:sibling_id] = delete_node[:sibling_id]
      ActiveRecord::Base.transaction do
        left_node.save!()
        delete_node.delete()
      end
    else
      parent_node[:child_id] = delete_node[:sibling_id]
      ActiveRecord::Base.transaction do
        parent_node.save!()
        delete_node.delete()
      end
    end
    render status: 200, json: delete_node.as_json
  end
end
