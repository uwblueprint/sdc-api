# == Schema Information
#
# Table name: flowchart_icons
#
#  id         :bigint           not null, primary key
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :flowchart_icon do
    url { "MyString" }
  end
end
