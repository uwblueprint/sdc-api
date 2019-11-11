# frozen_string_literal: true

# create empty flowchart
Flowchart.create(title: 'chart 1', description: 'this chart is about abc', height: 0)
# # create some nodes
FlowchartNode.create(header: 'l1', text: 'l1', flowchart_id: 1, is_root: false)
FlowchartNode.create(header: 'l3', text: 'l3', flowchart_id: 1, is_root: false)
FlowchartNode.create(header: 'l2', text: 'l2', flowchart_id: 1, is_root: false, sibling_id: 2)
FlowchartNode.create(header: 'm3', text: 'm3', flowchart_id: 1, is_root: false)
FlowchartNode.create(header: 'm2', text: 'm2', flowchart_id: 1, is_root: false, child_id: 3)
FlowchartNode.create(header: 'm1', text: 'm1', flowchart_id: 1, is_root: false, child_id: 1)
FlowchartNode.create(header: 'n3', text: 'n3', flowchart_id: 1, is_root: false, child_id: 4)
FlowchartNode.create(header: 'n2', text: 'n2', flowchart_id: 1, is_root: false, child_id: 5, sibling_id: 7)
FlowchartNode.create(header: 'n1', text: 'n1', flowchart_id: 1, is_root: false, child_id: 6, sibling_id: 8)
FlowchartNode.create(header: 'root', text: 'root', flowchart_id: 1, is_root: true, child_id: 9)

flowchart = Flowchart.find_by(id: 1)
flowchart.update_attributes(root_id: 10)
