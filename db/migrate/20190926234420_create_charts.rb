class CreateCharts < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.numeric :chart_id
      t.timestamps
    end
  end
end
