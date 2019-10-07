class RemoveChartIdFromQuestions < ActiveRecord::Migration[6.0]
  def change
    remove_column :questions, :chart_id
  end
end
