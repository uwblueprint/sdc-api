# frozen_string_literal: true

class AddFkRelationToFlowchartsTable < ActiveRecord::Migration[6.0]
  def change
    change_table :flowcharts do |t|
      t.references :root, foreign_key: { to_table: :flowchart_nodes }
    end
  end
end
