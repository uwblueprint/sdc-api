# frozen_string_literal: true

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
