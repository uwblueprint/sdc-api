# frozen_string_literal: true

class FlowchartNode < ApplicationRecord
  def self.get_root_node(flowchart_id)
    return FlowchartNode.find_by(flowchart_id: flowchart_id, is_root: true)
  end
end
