# frozen_string_literal: true

class FlowchartNode < ApplicationRecord
  belongs_to :flowchart

  def soft_delete
    self.deleted = true
    save
    sibling = FlowchartNode.find_by(id: sibling_id)
    child = FlowchartNode.find_by(id: child_id)
    sibling&.soft_delete
    child&.soft_delete
  end
end
