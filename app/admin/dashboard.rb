# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Recent Flowcharts' do
          table_for Flowchart.order('id').limit(10) do
            column('Title') { |f| link_to(f.title, admin_flowchart_path(f.id)) }
            column('Description', &:description)
          end
        end
      end
      column do
        panel 'Recent Icons' do
          table_for FlowchartIcon.order('id').limit(10) do
            column('ID') { |i| link_to(i.id, admin_flowchart_path(i.id)) }
            column('URL', &:url)
          end
        end
      end
    end
    columns do
      column do
        panel 'Info' do
          para 'Welcome to the admin dashboard for SDC flowcharts!'
        end
      end
    end
  end
end
