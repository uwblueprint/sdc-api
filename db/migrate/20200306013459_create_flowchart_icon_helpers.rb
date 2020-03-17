class CreateFlowchartIconHelpers < ActiveRecord::Migration[6.0]
  def change
    create_table :flowchart_icon_helpers do |t|
      t.belongs_to :flowchart_node
      t.belongs_to :flowchart_icon
      t.timestamps
    end
  end
end
