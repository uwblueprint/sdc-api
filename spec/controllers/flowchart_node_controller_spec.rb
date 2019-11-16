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
      end

      it 'returns status code 200' do
        put :update, params: @params
        expect(response.response_code).to eq(200)
      end

      it 'renders the json of the updated node' do
        expected = @node_1
        expected.text = 'mock text'
        expected.header = 'mock header'
        expected.button_text = 'mock button text'
        expected.next_question = 'mock next question'
        put :update, params: @params
        expect(JSON.parse(response.body).except(*@exclude_keys)).to eq(expected.attributes.except(*@exclude_keys))
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
end
