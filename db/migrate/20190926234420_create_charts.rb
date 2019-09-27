class CreateCharts < ActiveRecord::Migration[6.0]
  def change
    create_table :charts do |t|
      t.string :chart_id
      t.index [:chart_id]
      t.timestamps
    end
  end
end
