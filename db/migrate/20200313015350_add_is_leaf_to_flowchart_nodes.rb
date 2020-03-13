class AddIsLeafToFlowchartNodes < ActiveRecord::Migration[6.0]
  def change
    add_column :flowchart_nodes, :is_leaf, :boolean, default: false
    change_column_null :flowchart_nodes, :is_leaf, false
  end
end
