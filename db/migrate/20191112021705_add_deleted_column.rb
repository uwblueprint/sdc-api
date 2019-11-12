# frozen_string_literal: true

class AddDeletedColumn < ActiveRecord::Migration[6.0]
  def change
    change_table :flowcharts do |t|
      t.boolean :deleted, null: false, default: false
    end
    change_table :flowchart_nodes do |t|
      t.boolean :deleted, null: false, default: false
    end
  end
end
