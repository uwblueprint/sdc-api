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

FactoryBot.define do
  factory :flowchart_icon_helper do
    
  end
end
