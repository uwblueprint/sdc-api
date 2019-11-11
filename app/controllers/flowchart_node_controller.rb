class FlowchartNodeController < ApplicationController
  def show
    id = params[:id]
    node = FlowchartNode.find_by(id: id)
    if !node
      render status: 404, json: { error: "No node found with id #{id}." }
    else
      render json: node.to_json
    end
  end

  def update
    id = params[:id]
    text = params[:text]
    header = params[:header]
    button_text = params[:button_text]
    next_question = params[:next_question]
    FlowchartNode.update(id, :id => id, :text => text, :header => header, :button_text => button_text)
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
      node_a.save()
      node_b.save()
    end
  end

  def delete
    # need to handle
    delete_id = params[:id]
    parent = FlowchartNode.find_by(child_id: delete_id)
    if !parent
      # TODO
    else
      # TODO
    end
  end
end
