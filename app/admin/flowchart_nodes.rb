ActiveAdmin.register FlowchartNode do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  belongs_to :flowchart
  # belongs_to :flowchart_node_id, class_name: 'FlowchartNode', optional: true
  # belongs_to :parent, class_name: 'FlowchartNode', optional: true
  permit_params :id, :text, :header, :button_text, :next_question, :is_root, :flowchart_id, :deleted, :flowchart_node_id
  # navigation_menu :default
  # menu false

  controller do
    def permitted_params
      params.permit :authenticity_token, :commit, flowchart_node: [:id, :text, :header, :button_text, :next_question, :is_root, :flowchart_id, :flowchart_node_id, :deleted,
        flowchart_icon_helpers_attributes: [:id, :flowchart_icon_id, :flowchart_node_id, :_destroy]]
    end
  end
  
  form do |f|
    f.inputs "Node Details" do
      f.input :id, label: "Node ID", input_html: { disabled: true }
      f.input :header, label: "Node Title"
      f.input :text, label: "Node Text"
      f.input :next_question, label: "Node Question"
      f.input :button_text, label: "Button Text"
      f.input :parent, label: "Parent Node", as: :select, collection: FlowchartNode.select(:header).where(flowchart_id: f.object.flowchart_id)
      f.input :is_root, label: "Root Node?"
      f.has_many :flowchart_icon_helpers, new_record: 'Add Icon', allow_destroy: true, heading: "Icons" do |i|
        i.input :flowchart_icon, label: "Icon ID"
      end
    end
    f.actions
  end

  # permit_params do
  #   permitted = [:text, :header, :button_text, :next_question, :child_id, :sibling_id, :is_root, :flowchart_id, :deleted, :flowchart_node_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end