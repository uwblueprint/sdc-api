# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Flowchart, type: :model do
  it 'is valid with valid attributes' do
    expect(Flowchart.create(title: 'title', description: 'description', "height": 0)).to be_valid
  end
  it 'is not valid without required attributes' do
    expect do
      Flowchart.create
    end.to raise_error
  end
end
