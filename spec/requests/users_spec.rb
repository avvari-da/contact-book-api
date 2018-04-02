require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  # initialize test data
  let!(:users) do
    create_list(:user, 10)
  end
  let(:user_id) do
    users.first.id
  end

  # Test suite for GET /users/:id
  describe 'GET /users/:id' do
    before do
      get "/users/#{user_id}"
    end

    context 'when the record exists' do
      it 'returns the user' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(user_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:user_id) do
        100
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end
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
      {email: 'user@test.com', password: 'test123'}
    end

    context 'when the request is valid' do
      before do
        post '/users', params: valid_attributes
      end

      it 'returns a user id & token' do
        expect(json['id']).not_to be_empty
        expect(json['access_token']).not_to be_empty
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request is invalid' do
      before do
        post '/users/login', params: valid_attributes
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
end