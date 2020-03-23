ActiveAdmin.register Flowchart do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # sidebar "Flowchart Details", only: [:show, :edit] do
  #   ul do
  #     li link_to "Flowchart nodes", admin_project_tickets_path(resource)
  #   end
  # end

  permit_params :title, :description, :root_id,
    flowchart_node_attributes: [:id, :text, :header, :button_text, :next_question, :child_id, :is_root, :flowchart_id, :_destroy]
    
    controller do
      def permitted_params
        params.permit flowchart: [:title, :description, :height, :root_id, :deleted,
        flowchart_nodes_attributes: [:id, :text, :header, :button_text, :next_question, :child_id, :is_root, :flowchart_id, :_destroy]]
      end
    end

  form do |f|
    f.inputs "Details" do
      f.input :title, label: "Flowchart title"
      f.input :description, label: "Description"
      # f.input :root_id, label: "Root Node ID" # make it so that this works with the nodes table?
    end

    f.inputs "Flowchart Nodes" do
      f.has_many :flowchart_nodes, new_record: true, allow_destroy: true, heading: false do |n|
        n.input :id, label: "Node ID", input_html: { disabled: true }
        n.input :header, label: "Node Title"
        n.input :text, label: "Node Text"
        n.input :next_question, label: "Node Question"
        n.input :button_text, label: "Button Text"
        n.input :parent, label: "Parent Node", as: :select, collection: FlowchartNode.select(:header).where(flowchart_id: f.object.id)
        n.input :is_root, label: "Root Node?"
      end
    end
    f.actions
  end

  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :description, :height, :root_id, :deleted]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end

# ActiveAdmin.register FlowchartNode do

#   # See permitted parameters documentation:
#   # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#   #
#   # Uncomment all parameters which should be permitted for assignment
#   # #
#   belongs_to :flowchart
#   # belongs_to :parent, class_name: 'FlowchartNode', optional: true
#   # validates :text, presence: true
#   # validates :header, presence: true
#   # validates :button_text, exclusion: { in: [''] }
#   # validates :next_question, exclusion: { in: [''] }
#   # validates :child_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
#   # validates :sibling_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
#   # validates :is_root, null: false
#   # validates :flowchart_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, null: false
#   # validates :deleted, inclusion: { in: [true, false] }

#   # permit_params :text, :header, :button_text, :next_question, :child_id, :is_root, :flowchart_id
#   permit_params :text, :header, :button_text, :next_question, :child_id, :sibling_id, :is_root, :flowchart_id, :deleted, :flowchart_node_id
#   #
#   # or
#   #
#   # permit_params do
#   #   permitted = [:text, :header, :button_text, :next_question, :child_id, :sibling_id, :is_root, :flowchart_id, :deleted, :flowchart_node_id]
#   #   permitted << :other if params[:action] == 'create' && current_user.admin?
#   #   permitted
#   # end
  
# end