require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  # initialize test data
  let!(:users) do
    create_list(:user, 10)
  end
  let(:user_id) do
    users.first.id
  end

  # Test suite for POST /users
  describe 'POST /users' do
    # valid payload
    let(:valid_attributes) do
      {name: 'Test User', email: 'user@test.com', password: 'test123'}
    end

    context 'when the request is valid' do
      before do
        post '/users', params: valid_attributes
      end

      it 'creates a user' do
        expect(json['name']).to eq('Test User')
        expect(json['email']).to eq('user@test.com')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before do
        post '/users', params: {name: 'Test User', email: 'user@test.com'}
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match(/Validation failed: Password can't be blank/)
      end
    end
  end

  # Test suite for POST /users/login
  describe 'POST /users/login' do
    # valid payload
    let(:valid_attributes) do
      {email: users.first.email, password: 'test12345'}
    end

    context 'when the request is valid' do
      before do
        post '/users/login', params: valid_attributes
      end

      it 'returns a user id & token' do
        expect(json).not_to be_empty
        expect(json['id']).to be > 0
        expect(json['token']).not_to be_empty
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request is invalid' do
      before do
        post '/users/login', params: {email: users.first.email}
      end

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

      it 'returns a validation failure message' do
        expect(response.body).to eq("{\"message\":\"Password incorrect\"}")
      end
    end
  end
end