class FlowchartController < ApplicationController
    def index
        @flowcharts = Flowchart.all
        render json: @questions
    end
end
