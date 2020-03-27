class BreadcrumbTitle < ActiveRecord::Migration[6.0]
  def change
    add_column :flowchart_nodes, :breadcrumb_title, :string
  end
end
