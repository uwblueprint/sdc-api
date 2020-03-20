# frozen_string_literal: true

# == Schema Information
#
# Table name: flowchart_icon_helpers
#
#  id                :bigint           not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  flowchart_icon_id :bigint
#  flowchart_node_id :bigint
#
# Indexes
#
#  index_flowchart_icon_helpers_on_flowchart_icon_id  (flowchart_icon_id)
#  index_flowchart_icon_helpers_on_flowchart_node_id  (flowchart_node_id)
#

class FlowchartIconHelper < ApplicationRecord
  belongs_to :flowchart_node
  belongs_to :flowchart_icon
end
