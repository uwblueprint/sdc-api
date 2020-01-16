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
  node_1 = FlowchartNode.create!(
      text: 'Node text 1',
      header: 'Node header 1',
      button_text: 'Button text 1',
      next_question: 'Next question 1',
      is_root: true,
      flowchart_id: flowchart.id,
  )
  node_2 = FlowchartNode.create!(
      text: 'Node text 2',
      header: 'Node header 2',
      button_text: 'Button text 2',
      next_question: 'Next question 2',
      is_root: false,
      flowchart_id: flowchart.id
  )

  # set foreign keys
  flowchart[:root_id] = node_1.id
  node_1[:child_id] = node_2.id

  # write changes
  flowchart.save!
  node_1.save!
end
