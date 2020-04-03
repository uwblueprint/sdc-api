# frozen_string_literal: true

ActiveAdmin.register Flowchart do
  menu priority: 3
  sidebar 'Flowchart Details', only: %i[show edit] do
    ul do
      li link_to 'Flowchart Nodes', admin_flowchart_flowchart_nodes_path(resource)
    end
  end

  permit_params :id, :title, :description, :root_id, :created_at, :updated_at, :deleted, :height,
                flowchart_node_attributes: [:id, :text, :header, :button_text, :next_question, :child_id, :sibling_id, :is_root, :flowchart_id, :flowchart_node_id, :is_leaf, :breadcrumb_title, :deleted, :_destroy,
                                            flowchart_icon_helpers_attributes: %i[id flowchart_icon_id flowchart_node_id _destroy]]

  controller do
    def permitted_params
      params.permit :authenticity_token, :commit, flowchart: [:id, :title, :description, :root_id, :created_at, :updated_at, :deleted, :height,
                                                              flowchart_nodes_attributes: [:id, :text, :header, :button_text, :next_question, :is_root, :flowchart_id, :flowchart_node_id, :is_leaf, :breadcrumb_title, :deleted, :_destroy,
                                                                                           flowchart_icon_helpers_attributes: %i[id flowchart_icon_id flowchart_node_id _destroy]]]
    end
  end

  form do |f|
    f.inputs 'Details' do
      f.input :title, label: 'Flowchart title'
      f.input :description, label: 'Description'
      f.hidden_field :height, value: 1
      unless f.object.new_record?
        f.input :root_id, label: 'Root Node ID'
      end
    end
    unless f.object.new_record?
      f.inputs 'Flowchart Nodes' do
        f.has_many :flowchart_nodes, new_record: true, allow_destroy: true, heading: false do |n|
          n.input :id, label: 'Node ID', input_html: { disabled: true }
          n.input :header, label: 'Node Title'
          n.input :text, label: 'Node Text'
          n.input :next_question, label: 'Node Question'
          n.input :breadcrumb_title, label: 'Breadcrumb Title'
          n.input :flowchart_node_id, label: 'Parent Node', as: :select, collection: FlowchartNode.where(flowchart_id: f.object.id)
          n.input :is_root, label: 'Root Node?'
          n.input :is_leaf, label: 'Leaf Node?'
          n.has_many :flowchart_icon_helpers, new_record: 'Add Icon', allow_destroy: true, heading: 'Node Icons' do |i|
            i.input :flowchart_icon, label: 'Icon ID'
          end
        end
      end
    end
    f.actions
  end
end
