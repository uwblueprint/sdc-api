# frozen_string_literal: true

ActiveAdmin.register FlowchartIcon, as: 'Icon' do
  permit_params :url
end
