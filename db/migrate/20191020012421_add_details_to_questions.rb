class AddDetailsToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :question, :string
    add_column :questions, :options, :string, array: true, default: []
    add_column :questions, :is_root, :boolean
  end
end
