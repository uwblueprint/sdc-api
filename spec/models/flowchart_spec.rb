# frozen_string_literal: true

# == Schema Information
#
# Table name: flowcharts
#
#  id          :bigint           not null, primary key
#  title       :string           not null
#  description :string           not null
#  height      :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  root_id     :bigint
#  deleted     :boolean          default(FALSE), not null
#

require 'rails_helper'

RSpec.describe Flowchart, type: :model do
  it 'is valid with valid attributes' do
    expect(Flowchart.create(title: 'title', description: 'description', "height": 0, "deleted": false)).to be_valid
  end
  it 'is not valid without required attributes' do
    expect do
      Flowchart.create!
    end.to raise_error(ActiveRecord::RecordInvalid)
  end
end
