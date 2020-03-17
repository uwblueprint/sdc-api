# == Schema Information
#
# Table name: flowchart_icon_helpers
#
#  id                :bigint           not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  flowchart_icon_id :integer
#  flowchart_node_id :integer
#

class FlowchartIconHelper < ApplicationRecord
    belongs_to :flowchart_node
    belongs_to :flowchart_icon
end
