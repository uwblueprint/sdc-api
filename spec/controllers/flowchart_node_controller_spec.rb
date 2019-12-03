# frozen_string_literal: true

require 'rails_helper'
require 'json'

RSpec.describe FlowchartNodeController, type: :controller do
  before(:each) do
    Flowchart.create(id: 100, title: 'title', description: 'description', height: 0)
    @node8 = FlowchartNode.create(
      id: 8,
      text: 'h',
      header: 'hh',
      button_text: 'hhh',
      next_question: 'hhhh',
      is_root: false,
      flowchart_id: 100,
      deleted: false
    )
    @node7 = FlowchartNode.create(
      id: 7,
      text: 'g',
      header: 'gg',
      button_text: 'ggg',
      next_question: 'gggg',
      is_root: false,
      flowchart_id: 100,
      deleted: false
    )
    @node6 = FlowchartNode.create(
      id: 6,
      text: 'f',
      header: 'ff',
      button_text: 'fff',
      next_question: 'ffff',
      child_id: 8,
      sibling_id: 7,
      is_root: false,
      flowchart_id: 100,
      deleted: false
    )
    @node5 = FlowchartNode.create(
      id: 5,
      text: 'e',
      header: 'ee',
      button_text: 'eee',
      next_question: 'eeee',
      is_root: false,
      flowchart_id: 100,
      deleted: false
    )
    @node4 = FlowchartNode.create(
      id: 4,
      text: 'd',
      header: 'dd',
      button_text: 'ddd',
      next_question: 'dddd',
      sibling_id: 5,
      is_root: false,
      flowchart_id: 100,
      deleted: false
    )
    @node3 = FlowchartNode.create(
      id: 3,
      text: 'c',
      header: 'cc',
      button_text: 'ccc',
      next_question: 'cccc',
      child_id: 6,
      sibling_id: 4,
      is_root: false,
      flowchart_id: 100,
      deleted: false
    )
    @node2 = FlowchartNode.create(
      id: 2,
      text: 'b',
      header: 'bb',
      button_text: 'bbb',
      next_question: 'bbbb',
      child_id: 3,
      is_root: false,
      flowchart_id: 100,
      deleted: false
    )
    @node1 = FlowchartNode.create(
      id: 1,
      text: 'a',
      header: 'aa',
      button_text: 'aaa',
      next_question: 'aaaa',
      child_id: 2,
      is_root: true,
      flowchart_id: 100,
      deleted: false
    )
    # The primary key sequence isn't being updated properly in the test database, this line corrects the sequence
    ActiveRecord::Base.connection.reset_pk_sequence!('flowchart_nodes')
    @exclude_keys = %w[created_at updated_at]
  end

  describe '.create' do
    before(:each) do
      @params = {
        node: {
          text: 'mock text',
          header: 'mock header',
          button_text: 'mock button text',
          next_question: 'mock next question'
        }
      }
    end

    context 'when given a valid previous id' do
      it 'returns status code 200' do
        @params[:prev_id] = 4
        @params[:is_child] = true
        post :create, params: @params
        expect(response.response_code).to eq(200)
      end

      it 'renders json of the newly created node' do
        @params[:prev_id] = 4
        @params[:is_child] = true
        expected = {
          'text' => 'mock text',
          'header' => 'mock header',
          'button_text' => 'mock button text',
          'next_question' => 'mock next question',
          'child_id' => nil,
          'sibling_id' => nil,
          'is_root' => false,
          'flowchart_id' => 100,
          'deleted' => false
        }
        post :create, params: @params
        res = JSON.parse(response.body)
        res.delete('updated_at')
        res.delete('created_at')
        res.delete('id')
        expect(res).to eq(expected)
      end

      it 'saves the new node to the database' do
        expected = {
          'text' => 'mock text',
          'header' => 'mock header',
          'button_text' => 'mock button text',
          'next_question' => 'mock next question',
          'child_id' => nil,
          'sibling_id' => nil,
          'is_root' => false,
          'flowchart_id' => 100,
          'deleted' => false
        }
        @params[:prev_id] = 4
        @params[:is_child] = true
        post :create, params: @params
        res = JSON.parse(response.body)
        new_node = FlowchartNode.find(res['id'])
        expect(new_node.attributes.except(*@exclude_keys, 'id')).to eq(expected)
      end

      context 'when is_child is true' do
        it 'updates child_id of the parent node to the new node' do
          @params[:prev_id] = 3
          @params[:is_child] = true
          post :create, params: @params
          res = JSON.parse(response.body)
          new_id = res['id']
          parent_node = FlowchartNode.find(3)
          expect(parent_node.child_id).to be new_id
        end

        it 'updates child_id of the new node to the child_id of the parent' do
          @params[:prev_id] = 3
          @params[:is_child] = true
          parent_node = FlowchartNode.find(3)
          post :create, params: @params
          res = JSON.parse(response.body)
          expect(res['child_id']).to be parent_node.child_id
        end
      end

      context 'when is_child is false' do
        it 'updates sibling_id of the previous node to the new node' do
          @params[:prev_id] = 3
          @params[:is_child] = false
          post :create, params: @params
          res = JSON.parse(response.body)
          new_id = res['id']
          parent_node = FlowchartNode.find(3)
          expect(parent_node.sibling_id).to be new_id
        end

        it 'updates sibling_id of the new node to the sibling_id of the previous' do
          @params[:prev_id] = 3
          @params[:is_child] = false
          parent_node = FlowchartNode.find(3)
          post :create, params: @params
          res = JSON.parse(response.body)
          expect(res['sibling_id']).to be parent_node.sibling_id
        end
      end
    end

    context 'when given an invalid previous id' do
      before(:each) do
        @params[:prev_id] = 100
        @params[:is_child] = true
      end

      it 'throws a record not found error' do
        expect do
          post :create, params: @params
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when given an invalid body' do
      before(:each) do
        @params[:prev_id] = 3
        @params[:is_child] = true
        @params[:node][:text] = nil
      end

      it 'throws a record invalid error' do
        expect do
          post :create, params: @params
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '.show' do
    context 'when given a valid id' do
      it 'returns status code 200' do
        get :show, params: { id: 1 }
        expect(response.response_code).to eq(200)
      end

      it 'renders the correct json' do
        get :show, params: { id: 1 }
        expect(response.body).to eq(@node1.to_json)
      end
    end

    context 'when given an invalid id' do
      it 'throws a record not found error' do
        expect do
          get :show, params: { id: 100 }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '.update' do
    before(:each) do
      @params = {
        node: {
          text: 'mock text',
          header: 'mock header',
          button_text: 'mock button text',
          next_question: 'mock next question'
        }
      }
    end

    context 'when given a valid id' do
      before(:each) do
        @params[:id] = 1

        @expected = @node1
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

      it 'throws a record not found error' do
        expect do
          put :update, params: @params
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when given an invalid body' do
      before(:each) do
        @params[:id] = 1
        @params[:node][:text] = nil
      end

      it 'throws a record invalid error' do
        expect do
          put :update, params: @params
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '.swap' do
    context 'when given valid ids' do
      before(:each) do
        @params = {
          id_a: '3',
          id_b: '4'
        }
        @expected = {
          'new_a' => {
            'id' => 3,
            'text' => 'd',
            'header' => 'dd',
            'button_text' => 'ddd',
            'next_question' => 'dddd',
            'child_id' => nil,
            'sibling_id' => 4,
            'is_root' => false,
            'flowchart_id' => 100,
            'deleted' => false
          },
          'new_b' => {
            'id' => 4,
            'text' => 'c',
            'header' => 'cc',
            'button_text' => 'ccc',
            'next_question' => 'cccc',
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
          id_b: '200'
        }
      end

      it 'throws a record not found error' do
        expect do
          put :swap, params: @params
        end.to raise_error(ActiveRecord::RecordNotFound)
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
        node6 = FlowchartNode.find(6)
        node7 = FlowchartNode.find(7)
        node8 = FlowchartNode.find(8)
        deleted_status = [node6.deleted, node7.deleted, node8.deleted]
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
        @params = { id: '100' }
      end

      it 'throws a record not found error' do
        expect do
          delete :delete, params: @params
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
