class AddDeletedColumn < ActiveRecord::Migration[6.0]
  def change
    change_table :flowcharts do |t|
      t.boolean :deleted, null: false
    end
    change_table :flowchart_nodes do |t|
      t.boolean :deleted, null: false
    end
  end
end
