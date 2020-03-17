class AddFlowchartNodeIdToFlowchartIconHelper < ActiveRecord::Migration[6.0]
  def change
    add_column :flowchart_icon_helpers, :flowchart_node_id, :integer
  end
end
