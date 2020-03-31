# frozen_string_literal: true

ActiveAdmin.register FlowchartNode do
  sidebar 'Flowchart Details', only: %i[show edit] do
    ul do
      li link_to 'Node Icons', admin_icon_connectors_path('q[flowchart_node_id_eq]' => flowchart_node.id)
    end
  end

  belongs_to :flowchart
  permit_params :id, :text, :header, :next_question, :is_root, :flowchart_id, :deleted, :flowchart_node_id, :flowchart_id, :is_leaf, :breadcrumb_title,
                flowchart_icon_helpers_attributes: %i[id flowchart_icon_id flowchart_node_id _destroy]

  controller do
    def permitted_params
      params.permit :authenticity_token, :commit, :_method, :flowchart_id, :id, flowchart_node: [:id, :text, :header, :breadcrumb_title, :next_question, :is_root, :flowchart_id, :flowchart_node_id, :is_leaf, :deleted, :flowchart_id,
                                                                                                 flowchart_icon_helpers_attributes: %i[id flowchart_icon_id flowchart_node_id _destroy]]
    end
  end
end
