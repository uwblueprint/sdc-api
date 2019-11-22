# frozen_string_literal: true

require 'rails_helper'
require 'json'

RSpec.describe FlowchartController, type: :controller do
  before(:each) do
    # create empty flowchart.
    Flowchart.create(id: 1, title: 'chart 1', description: 'this chart is about abc', height: 0, deleted: false)

    # # create some nodes
    FlowchartNode.create(id: 2, header: 'l1', text: 'l1', flowchart_id: 1, is_root: false)
    FlowchartNode.create(id: 3, header: 'l3', text: 'l3', flowchart_id: 1, is_root: false)
    FlowchartNode.create(id: 4, header: 'l2', text: 'l2', flowchart_id: 1, is_root: false, sibling_id: 3)
    FlowchartNode.create(id: 5, header: 'm3', text: 'm3', flowchart_id: 1, is_root: false)
    FlowchartNode.create(id: 6, header: 'm2', text: 'm2', flowchart_id: 1, is_root: false, child_id: 4)
    FlowchartNode.create(id: 7, header: 'm1', text: 'm1', flowchart_id: 1, is_root: false, child_id: 2)
    FlowchartNode.create(id: 8, header: 'n3', text: 'n3', flowchart_id: 1, is_root: false, child_id: 5)
    FlowchartNode.create(id: 9, header: 'n2', text: 'n2', flowchart_id: 1, is_root: false, child_id: 6, sibling_id: 8)
    FlowchartNode.create(id: 10, header: 'n1', text: 'n1', flowchart_id: 1, is_root: false, child_id: 7, sibling_id: 9)
    FlowchartNode.create(id: 1, flowchart_id: 1, text: 'New Node', header: 'Options', is_root: true, child_id: 10, deleted: false)
    flowchart = Flowchart.find_by(id: 1)
    flowchart.update_attributes(root_id: 1)
    # The primary key sequence isn't being updated properly in the test database, this line corrects the sequence
    ActiveRecord::Base.connection.reset_pk_sequence!('flowcharts')
    ActiveRecord::Base.connection.reset_pk_sequence!('flowchart_nodes')
    @exclude_keys = %w[created_at updated_at]
  end

  describe '.create' do
    before(:each) do
      @body =
        {
          'title': 'test',
          'description': 'test desc',
          'height': 0,
          'deleted': false
        }
    end

    it 'renders json of the newly created flowchart' do
      expected = {
        'title' => 'test',
        'description' => 'test desc',
        'height' => 0,
        'root_id' => 11,
        'deleted' => false
      }
      post :create, body: @body.to_json
      res = JSON.parse(response.body)
      res.delete('updated_at')
      res.delete('created_at')
      res.delete('id')
      expect(res).to eq(expected)
    end
  end

  describe '.update' do
    before(:each) do
      @body =
        {
          'title': 'updated',
          'description': 'updated',
          'height': 3,
          'deleted': false
        }
      @params = {
        'id': 1
      }
    end

    it 'renders updated flowchart' do
      expected = {
        'title': 'updated',
        'description': 'updated',
        'height': 3,
        'deleted': false
      }
      post :update, params: @params, body: @body.to_json
      res = JSON.parse(response.body)
      res.delete('updated_at')
      res.delete('created_at')
      res.delete('id')
      res.delete('root_id')
      expect(res.to_json).to eq(expected.to_json)
    end
  end

  describe '.delete' do
    before(:each) do
      Flowchart.create(id: 3, title: 'tmp', description: 'to be deleted', height: 0, deleted: false)
      @params = {
        'id': 3
      }
    end

    it 'renders deleted flowchart' do
      expected = {
        'title': 'tmp',
        'description': 'to be deleted',
        'height': 0,
        'deleted': true
      }
      post :delete, params: @params
      res = JSON.parse(response.body)
      res.delete('updated_at')
      res.delete('created_at')
      res.delete('id')
      res.delete('root_id')
      expect(res.to_json).to eq(expected.to_json)
    end
  end

  describe '.get all' do
    it 'renders all flowcharts' do
      post :all_flowcharts
      res = JSON.parse(response.body)
      expect(res.size).to eq(1)
      # We created one initially in the before each. Anything created within a describe block gets cleaned up (ie from the create/delete tests)
    end
  end

  describe 'get nonexistent flowcahrt' do
    before(:each) do
      @params = {
        'id': 5
      }
    end

    it 'returns 404' do
      post :serialized_flowchart_by_id, params: @params
      expect(response.status).to eq(404)
    end
  end

  describe 'update nonexistent flowchart' do
    before(:each) do
      @body =
        {
          'title': 'updated',
          'description': 'updated',
          'height': 3,
          'deleted': false
        }
      @params = {
        'id': 5
      }
    end

    it 'returns 404' do
      post :update, params: @params, body: @body.to_json
      expect(response.status).to eq(404)
    end
  end

  describe 'delete nonexistent flowchart' do
    before(:each) do
      Flowchart.create(id: 3, title: 'tmp', description: 'to be deleted', height: 0, deleted: false)
      @params = {
        'id': 5
      }
    end

    it 'returns 404' do
      post :delete, params: @params
      expect(response.status).to eq(404)
    end
  end

  describe '.get serialized' do
    before(:each) do
      @params = {
        'id': 1
      }
    end

    it 'renders a flowchart with expected values' do
      expected = {
        'flowchart': {
          'id': 1,
          'title': 'chart 1',
          'description': 'this chart is about abc',
          'height': 3,
          'root_id': 1,
          'deleted': false
        },
        'flowchartnodes': {
          "1": {
            'button_text' => nil,
            'child_id' => 10,
            'deleted' => false,
            'flowchart_id' => 1,
            'header' => 'Options',
            'id' => 1,
            'is_root' => true,
            'next_question' => nil,
            'sibling_id' => nil,
            'text' => 'New Node'
          },
          "10": {
            'button_text' => nil,
            'child_id' => 7,
            'deleted' => false,
            'flowchart_id' => 1,
            'header' => 'n1',
            'id' => 10,
            'is_root' => false,
            'next_question' => nil,
            'sibling_id' => 9,
            'text' => 'n1'
          },
          "2": {
            'button_text' => nil,
            'child_id' => nil,
            'deleted' => false,
            'flowchart_id' => 1,
            'header' => 'l1',
            'id' => 2,
            'is_root' => false,
            'next_question' => nil,
            'sibling_id' => nil,
            'text' => 'l1'
          },
          "3": {
            'button_text' => nil,
            'child_id' => nil,
            'deleted' => false,
            'flowchart_id' => 1,
            'header' => 'l3',
            'id' => 3,
            'is_root' => false,
            'next_question' => nil,
            'sibling_id' => nil,
            'text' => 'l3'
          },
          "4": {
            'button_text' => nil,
            'child_id' => nil,
            'deleted' => false,
            'flowchart_id' => 1,
            'header' => 'l2',
            'id' => 4,
            'is_root' => false,
            'next_question' => nil,
            'sibling_id' => 3,
            'text' => 'l2'
          },
          "5": {
            'button_text' => nil,
            'child_id' => nil,
            'deleted' => false,
            'flowchart_id' => 1,
            'header' => 'm3',
            'id' => 5,
            'is_root' => false,
            'next_question' => nil,
            'sibling_id' => nil,
            'text' => 'm3'
          },
          "6": {
            'button_text' => nil,
            'child_id' => 4,
            'deleted' => false,
            'flowchart_id' => 1,
            'header' => 'm2',
            'id' => 6,
            'is_root' => false,
            'next_question' => nil,
            'sibling_id' => nil,
            'text' => 'm2'
          },
          "7": {
            'button_text' => nil,
            'child_id' => 2,
            'deleted' => false,
            'flowchart_id' => 1,
            'header' => 'm1',
            'id' => 7,
            'is_root' => false,
            'next_question' => nil,
            'sibling_id' => nil,
            'text' => 'm1'
          },
          "8": {
            'button_text' => nil,
            'child_id' => 5,
            'deleted' => false,
            'flowchart_id' => 1,
            'header' => 'n3',
            'id' => 8,
            'is_root' => false,
            'next_question' => nil,
            'sibling_id' => nil,
            'text' => 'n3'
          },
          "9": {
            'button_text' => nil,
            'child_id' => 6,
            'deleted' => false,
            'flowchart_id' => 1,
            'header' => 'n2',
            'id' => 9,
            'is_root' => false,
            'next_question' => nil,
            'sibling_id' => 8,
            'text' => 'n2'
          }
        },
        'adjacency_list': {
          '1' => [10, 9, 8],
          '10' => [7],
          '2' => [],
          '3' => [],
          '4' => [],
          '5' => [],
          '6' => [4, 3],
          '7' => [2],
          '8' => [5],
          '9' => [6]
        }
      }
      post :serialized_flowchart_by_id, params: @params
      res = JSON.parse(response.body).with_indifferent_access
      res[:flowchart].delete('updated_at')
      res[:flowchart].delete('created_at')
      res[:flowchartnodes].each do |id, _node|
        res[:flowchartnodes][id].delete('updated_at')
        res[:flowchartnodes][id].delete('created_at')
      end

      # Compares two ruby objects. The order of the keys will not matter.
      expect(res).to eq(JSON.parse(expected.to_json))
    end
  end
end
