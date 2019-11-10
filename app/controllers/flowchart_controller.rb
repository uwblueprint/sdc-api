# frozen_string_literal: true

class FlowchartController < ApplicationController
    def get_by_id()
        @flowchartnodes = FlowchartNode.all
        flowchart = Flowchart.find(params[:id])
        root_node = FlowchartNode.get_root_node(params[:id])
        
        p @flowchartnodes 
        p flowchart
        p root_node
        render json: @flowchartnodes
    end
end
