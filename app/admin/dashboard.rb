# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Recent Flowcharts' do
          table_for Flowchart.order('id').limit(10) do
            column('Title') { |f| f.title }
            column('Description') { |f| f.description }
          end
        end
      end
      column do
        panel 'Recent Icons' do
          table_for FlowchartIcon.order('id').limit(10) do
            column('ID') { |icon| icon.id }
            column('URL') { |icon| icon.url }
          end
        end
      end
    end
    columns do
      column do
        panel 'Info' do
          para 'Welcome to ActiveAdmin!'
        end
      end
    end
  end
end
