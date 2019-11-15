# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlowchartNode, type: :model do
  before(:each) do
    Flowchart.create(id: 100, title: 'title', description: 'description', height: 0)
  end

  it 'is valid with valid attributes' do
    expect(FlowchartNode.create(
      id: 1,
      text: "text",
      header: "header",
      button_text: "button_text",
      next_question: "next_question",
      is_root: true,
      flowchart_id: 100
    )).to be_valid
  end

  it 'is not valid without required attributes' do
    expect do
      FlowchartNode.create!
    end.to raise_error(ActiveRecord::RecordInvalid)
  end
end
