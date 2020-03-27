ActiveAdmin.register FlowchartNode do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  belongs_to :flowchart
  # belongs_to :flowchart_node_id, class_name: 'FlowchartNode', optional: true
  # belongs_to :parent, class_name: 'FlowchartNode', optional: true
  permit_params :id, :text, :header, :button_text, :next_question, :is_root, :flowchart_id, :deleted, :flowchart_node_id, :flowchart_id,
   flowchart_icon_helpers_attributes: [:id, :flowchart_icon_id, :flowchart_node_id, :_destroy]
  # navigation_menu :default
  # menu false

  controller do
    def permitted_params
      params.permit :authenticity_token, :commit, :_method, :flowchart_id, :id, flowchart_node: [:id, :text, :header, :button_text, :next_question, :is_root, :flowchart_id, :flowchart_node_id, :is_leaf, :deleted, :flowchart_id,
        flowchart_icon_helpers_attributes: [:id, :flowchart_icon_id, :flowchart_node_id, :_destroy]]
    end
  end
  
  # form do |f|
  #   f.inputs "Node Details" do
  #     f.input :id, label: "Node ID", input_html: { disabled: true }
  #     f.input :header, label: "Node Title"
  #     f.input :text, label: "Node Text"
  #     f.input :next_question, label: "Node Question"
  #     f.input :button_text, label: "Button Text"
  #     f.input :flowchart_node_id, label: "parent id", as: :select, collection: FlowchartNode.select(:header).where(flowchart_id: f.object.flowchart_id)
  #     # f.input :parent, label: "Parent Node", as: :select, collection: FlowchartNode.select(:header).where(flowchart_id: f.object.flowchart_id)
  #     f.input :is_root, label: "Root Node?"
  #     f.has_many :flowchart_icon_helpers, new_record: 'Add Icon', allow_destroy: true, heading: "Icons" do |i|
  #       i.input :flowchart_icon, label: "Icon ID"
  #     end
  #   end
  #   f.actions
  # end

  # permit_params do
  #   permitted = [:text, :header, :button_text, :next_question, :child_id, :sibling_id, :is_root, :flowchart_id, :deleted, :flowchart_node_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end

# Started POST "/admin/flowcharts/1/flowchart_nodes/6" for ::1 at 2020-03-26 20:07:17 -0400
# Processing by Admin::FlowchartNodesController#update as HTML
#   Parameters: {"authenticity_token"=>"Xi2dG+nLT8Y+TzYmjMG/bkPbXey6gDq5rdf/cf7aXDqpaX74BWTLqKn4FUwFftsfaZONTONu2MFS7Fyfy1F8sA==", "flowchart_node"=>{"header"=>"Node header 6", "text"=>"Node text 6", "next_question"=>"Next question 6", "button_text"=>"Button text 6", "flowchart_node_id"=>"", "is_root"=>"0", "flowchart_icon_helpers_attributes"=>{"0"=>{"flowchart_icon_id"=>"1", "_destroy"=>"0", "id"=>"2"}}}, "commit"=>"Update Flowchart node", "flowchart_id"=>"1", "id"=>"6"}
#   AdminUser Load (1.8ms)  SELECT "admin_users".* FROM "admin_users" WHERE "admin_users"."id" = $1 ORDER BY "admin_users"."id" ASC LIMIT $2  [["id", 1], ["LIMIT", 1]]
#   Flowchart Load (8.1ms)  SELECT "flowcharts".* FROM "flowcharts" WHERE "flowcharts"."id" = $1 LIMIT $2  [["id", 1], ["LIMIT", 1]]
#   FlowchartNode Load (17.7ms)  SELECT "flowchart_nodes".* FROM "flowchart_nodes" WHERE "flowchart_nodes"."flowchart_id" = $1 AND "flowchart_nodes"."id" = $2 LIMIT $3  [["flowchart_id", 1], ["id", 6], ["LIMIT", 1]]
#   FlowchartIconHelper Load (2.5ms)  SELECT "flowchart_icon_helpers".* FROM "flowchart_icon_helpers" WHERE "flowchart_icon_helpers"."flowchart_node_id" = $1 AND "flowchart_icon_helpers"."id" = $2  [["flowchart_node_id", 6], ["id", 2]]
# Redirected to http://localhost:5000/admin/flowcharts/1/flowchart_nodes/6
# Completed 302 Found in 67ms (ActiveRecord: 30.1ms | Allocations: 7483)
