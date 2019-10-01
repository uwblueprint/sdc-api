def greeting
  'Hello world!'
end

describe 'Greeting' do
  it 'returns message' do
    message = greeting
    expect(message).to eq('Hello world!')
  end
end
