# frozen_string_literal: true

ActiveAdmin.register FlowchartIcon, as: 'Icon' do
  menu priority: 5
  permit_params :url
end
