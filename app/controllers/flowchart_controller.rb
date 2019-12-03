# frozen_string_literal: true

class FlowchartController < ApplicationController
  def create
    @flowchart = Flowchart.new(JSON.parse(request.body.read))

    unless @flowchart.valid?
      render status: 400, json: { error: 'Invalid Flowchart params' }
      return
    end

    @flowchart = Flowchart.create(JSON.parse(request.body.read))
    root_node = FlowchartNode.create(flowchart_id: @flowchart.id, text: 'Insert Text', header: 'Insert Header', is_root: true, deleted: false)
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
    @flowcharts = Flowchart.where(deleted: false)
    @flowcharts.each(&:calculate_and_set_max_height)
    render json: Flowchart.where(deleted: false)
  end

  def serialized_flowchart_by_id
    flowchart = Flowchart.find_by(id: params[:id], deleted: false)

    unless Flowchart.find_by(id: params[:id], deleted: false)
      render status: 404, json: { error: "No flowchart found with id #{params[:id]}." }
      return
    end

    flowchart.calculate_and_set_max_height

    render json: flowchart.serialized
  end
end
