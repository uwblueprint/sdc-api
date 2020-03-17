# frozen_string_literal: true

case Rails.env
when 'development'
  # create seed data
  User.create!(
    email: ENV['SEED_USER_EMAIL'],
    password: ENV['SEED_USER_PASSWORD'],
    jti: SecureRandom.uuid
  )
  flowchart = Flowchart.create!(
    title: 'Flow Chart!!!!',
    description: 'this is an awesome flowchart',
    height: 1
  )
  node1 = FlowchartNode.create!(
    text: 'Node text 1',
    header: 'Node header 1',
    button_text: 'Button text 1',
    next_question: 'Next question 1',
    is_root: true,
    flowchart_id: flowchart.id,
    flowchart_node_id: nil
  )
  node2 = FlowchartNode.create!(
    text: 'Node text 2',
    header: 'Node header 2',
    button_text: 'Button text 2',
    next_question: 'Next question 2',
    is_root: false,
    flowchart_id: flowchart.id,
    flowchart_node_id: 1
  )
  node3 = FlowchartNode.create!(
    text: 'Node text 3',
    header: 'Node header 3',
    button_text: 'Button text 3',
    next_question: 'Next question 3',
    is_root: false,
    flowchart_id: flowchart.id,
    flowchart_node_id: 2
  )
  node4 = FlowchartNode.create!(
    text: 'Node text 4',
    header: 'Node header 4',
    button_text: 'Button text 4',
    next_question: 'Next question 4',
    is_root: false,
    flowchart_id: flowchart.id,
    flowchart_node_id: 2
  )

  # set foreign keys
  flowchart[:root_id] = node1.id
  node1[:child_id] = node2.id
  node2[:child_id] = node3.id
  node2[:child_id] = node4.id

  # write changes
  flowchart.save!
  node1.save!
end
