class ChangeNodeTextSize < ActiveRecord::Migration[6.0]
  def change
    change_column :flowchart_nodes, :text, :text
    change_column_null :flowchart_nodes, :text, true
  end
end
