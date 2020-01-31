# frozen_string_literal: true

class AddParentChildAssociationsToFlowchartNode < ActiveRecord::Migration[6.0]
  def change
    add_reference :flowchart_nodes, :flowchart_node, foreign_key: true
  end
end
