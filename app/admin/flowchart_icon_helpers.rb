# frozen_string_literal: true

ActiveAdmin.register FlowchartIconHelper, as: 'Icon Connectors' do
  menu priority: 6
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :flowchart_node_id, :flowchart_icon_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:flowchart_node_id, :flowchart_icon_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
