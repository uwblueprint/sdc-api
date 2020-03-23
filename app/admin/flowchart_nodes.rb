ActiveAdmin.register FlowchartNode do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  belongs_to :flowchart
  # belongs_to :parent, class_name: 'FlowchartNode', optional: true
  permit_params :text, :header, :button_text, :next_question, :is_root, :flowchart_id, :deleted
  navigation_menu :flowchart
  #
  # or
  #
  # permit_params do
  #   permitted = [:text, :header, :button_text, :next_question, :child_id, :sibling_id, :is_root, :flowchart_id, :deleted, :flowchart_node_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end

# TODO
# -submitting flowchart form doesn't work?
# -submitting flowchart node form doesn't update parent - dependency/nested/permitted params issue probably
# -make main page look nicer
# -display nodes with flowchart on view? and/or add nodes to menu/sidebar
# -update flowchart node form? (customize)