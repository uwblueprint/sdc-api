class CreateFlowchartIcons < ActiveRecord::Migration[6.0]
  def change
    create_table :flowchart_icons do |t|
      t.string :url, :null => false

      t.timestamps
    end
  end
end
