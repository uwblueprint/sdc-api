class ChangeNodeTextSize < ActiveRecord::Migration[6.0]
  def change
    change_column :flowchart_nodes, :text, :text
  end
end
