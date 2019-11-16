# frozen_string_literal: true

require 'rails_helper'
require 'json'

RSpec.describe FlowchartNodeController, type: :controller do
  before(:each) do
    Flowchart.create(id: 100, title: 'title', description: 'description', height: 0)
    @node_8 = FlowchartNode.create(
      id: 8,
      text: "h",
      header: "hh",
      button_text: "hhh",
      next_question: "hhhh",
      is_root: false,
      flowchart_id: 100,
      deleted: false
    )
    @node_7 = FlowchartNode.create(
      id: 7,
      text: "g",
      header: "gg",
      button_text: "ggg",
      next_question: "gggg",
      is_root: false,
      flowchart_id: 100,
      deleted: false
    )
    @node_6 = FlowchartNode.create(
      id: 6,
      text: "f",
      header: "ff",
      button_text: "fff",
      next_question: "ffff",
      child_id: 8,
      sibling_id: 7,
      is_root: false,
      flowchart_id: 100,
      deleted: false
    )
    @node_5 = FlowchartNode.create(
      id: 5,
      text: "e",
      header: "ee",
      button_text: "eee",
      next_question: "eeee",
      is_root: false,
      flowchart_id: 100,
      deleted: false
    )
    @node_4 = FlowchartNode.create(
      id: 4,
      text: "d",
      header: "dd",
      button_text: "ddd",
      next_question: "dddd",
      sibling_id: 5,
      is_root: false,
      flowchart_id: 100,
      deleted: false
    )
    @node_3 = FlowchartNode.create(
      id: 3,
      text: "c",
      header: "cc",
      button_text: "ccc",
      next_question: "cccc",
      child_id: 6,
      sibling_id: 4,
      is_root: false,
      flowchart_id: 100,
      deleted: false
    )
    @node_2 = FlowchartNode.create(
      id: 2,
      text: "b",
      header: "bb",
      button_text: "bbb",
      next_question: "bbbb",
      child_id: 3,
      is_root: false,
      flowchart_id: 100,
      deleted: false
    )
    @node_1 = FlowchartNode.create(
      id: 1,
      text: "a",
      header: "aa",
      button_text: "aaa",
      next_question: "aaaa",
      child_id: 2,
      is_root: true,
      flowchart_id: 100,
      deleted: false
    )
    @exclude_keys = ['created_at', 'updated_at']
  end

  describe '.show' do
    context 'when given a valid id' do
      it 'returns status code 200' do
        get :show, params: { id: 1 }
        expect(response.response_code).to eq(200)
      end

      it 'renders the correct json' do
        get :show, params: { id: 1 }
        expect(response.body).to eq(@node_1.to_json)
      end
    end

    context 'when given an invalid id' do
      it 'returns status code 404' do
        get :show, params: { id: 100 }
        expect(response.response_code).to eq(404)
      end

      it 'renders the error json' do
        error_json = { :error => 'No node found with id 100.' }.to_json
        get :show, params: { id: 100 }
        expect(response.body).to eq(error_json)
      end
    end
  end

  describe '.update' do
    before(:each) do
      @params = {
        text: 'mock text',
        header: 'mock header',
        button_text: 'mock button text',
        next_question: 'mock next question'
      }
    end

    context 'when given a valid id' do
      before(:each) do
        @params[:id] = 1

        @expected = @node_1
        @expected.text = 'mock text'
        @expected.header = 'mock header'
        @expected.button_text = 'mock button text'
        @expected.next_question = 'mock next question'
      end

      it 'returns status code 200' do
        put :update, params: @params
        expect(response.response_code).to eq(200)
      end

      it 'updates the node in the database' do
        put :update, params: @params
        updated_node = FlowchartNode.find(1)
        expect(updated_node.attributes.except(*@exclude_keys)).to eq(@expected.attributes.except(*@exclude_keys))
      end

      it 'renders the json of the updated node' do
        put :update, params: @params
        expect(JSON.parse(response.body).except(*@exclude_keys)).to eq(@expected.attributes.except(*@exclude_keys))
      end
    end

    context 'when given an invalid id' do
      before(:each) do
        @params[:id] = 100
      end

      it 'returns status code 404' do
        put :update, params: @params
        expect(response.response_code).to eq(404)
      end

      it 'renders the error json' do
        error_json = { :error => 'No node found with id 100.' }.to_json
        put :update, params: @params
        expect(response.body).to eq(error_json)
      end
    end
  end

  describe '.swap' do
    context 'when given valid ids' do
      before(:each) do
        @params = {
          id_a: '3',
          id_b: '4',
        }
        @expected = {
          'new_a' => {
            'id' => 3,
            'text' => "d",
            'header' => "dd",
            'button_text' => "ddd",
            'next_question' => "dddd",
            'child_id' => nil,
            'sibling_id' => 4,
            'is_root' => false,
            'flowchart_id' => 100,
            'deleted' => false
          },
          'new_b' => {
            'id' => 4,
            'text' => "c",
            'header' => "cc",
            'button_text' => "ccc",
            'next_question' => "cccc",
            'child_id' => 6,
            'sibling_id' => 5,
            'is_root' => false,
            'flowchart_id' => 100,
            'deleted' => false
          }
        }
      end

      it 'returns status code 200' do
        put :swap, params: @params
        expect(response.response_code).to eq(200)
      end

      it 'renders json containing the swapped nodes' do
        put :swap, params: @params
        res = JSON.parse(response.body)
        res['new_a'].delete('updated_at')
        res['new_a'].delete('created_at')
        res['new_b'].delete('updated_at')
        res['new_b'].delete('created_at')
        expect(res).to eq(@expected)
      end

      it 'updates node A with the contents of node B in the database' do
        put :swap, params: @params
        node_a = FlowchartNode.find(3)
        expect(node_a.attributes.except(*@exclude_keys)).to eq(@expected['new_a'])
      end

      it 'updates node B with the contents of node A in the database' do
        put :swap, params: @params
        node_b = FlowchartNode.find(4)
        expect(node_b.attributes.except(*@exclude_keys)).to eq(@expected['new_b'])
      end
    end

    context 'when given an invalid id' do
      before(:each) do
        @params = {
          id_a: '1',
          id_b: '200',
        }
      end

      it 'returns status code 404' do
        put :swap, params: @params
        expect(response.response_code).to eq(404)
      end

      it 'renders the error json' do
        error_json = { :error => 'Error finding nodes with the given ids.' }.to_json
        put :swap, params: @params
        expect(response.body).to eq(error_json)
      end
    end
  end

  describe '.delete' do
    context 'when given a valid id' do
      it 'returns status code 200' do
        delete :delete, params: { id: 3 }
        expect(response.response_code).to eq(200)
      end

      it 'renders json of the deleted node' do
        delete :delete, params: { id: 3 }
        deleted_node = FlowchartNode.find(3)
        expect(deleted_node.deleted).to be true
      end

      it 'soft deletes the subtree below the deleted node' do
        delete :delete, params: { id: 3 }
        node_6 = FlowchartNode.find(6)
        node_7 = FlowchartNode.find(7)
        node_8 = FlowchartNode.find(8)
        deleted_status = [node_6.deleted, node_7.deleted, node_8.deleted]
        expect(deleted_status).to match_array([true, true, true])
      end

      it 'updates the parent\'s child_id if a parent exists' do
        delete :delete, params: { id: 3 }
        parent_node = FlowchartNode.find(2)
        expect(parent_node.child_id).to be 4
      end

      it 'updates the left sibling\'s sibling_id if a left sibling exists' do
        delete :delete, params: { id: 4 }
        sibling_node = FlowchartNode.find(3)
        expect(sibling_node.sibling_id).to be 5
      end
    end

    context 'when given an invalid id' do
      before(:each) do
        @params = { id: '100'}
      end

      it 'returns status code 404' do
        delete :delete, params: @params
        expect(response.response_code).to eq(404)
      end

      it 'renders the error json' do
        error_json = { :error => 'No node found with id 100.' }.to_json
        delete :delete, params: @params
        expect(response.body).to eq(error_json)
      end
    end
  end
end
