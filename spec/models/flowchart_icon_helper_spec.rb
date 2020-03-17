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

require 'rails_helper'

RSpec.describe FlowchartIconHelper, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
