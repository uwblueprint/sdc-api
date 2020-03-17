# frozen_string_literal: true

# == Schema Information
#
# Table name: flowchart_icons
#
#  id         :bigint           not null, primary key
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FlowchartIcon < ApplicationRecord
  has_many :flowchart_icon_helpers
  has_many :flowchart_node, through: :flowchart_icon_helpers
end
