require 'rails_helper'

RSpec.describe 'Contacts API', type: :request do
  # initialize test data
  let!(:user) do
    create(:user)
  end
  let!(:contacts) do
    create_list(:contact, 10, user_id: user.id)
  end
  let(:user_id) do
    user.id
  end
  let(:user_token) do
    UserToken.where(user_id: user_id).update(active: false)
    UserToken.create!(user: user).access_token
  end
  let(:contact_id) do
    contacts.first.id
  end

  # Test suite for GET /users/:user_id/contacts
  describe 'GET /users/:user_id/contacts' do
    # make HTTP get request before each example
    before do
      get "/users/#{user_id}/contacts", params: nil, headers: { authorization: "Token #{user_token}" }
    end

    it 'returns contacts' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json['contacts'].count).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /users/:user_id/contacts/:id
  describe 'GET /users/:user_id/contacts/:id' do
    before do
      get "/users/#{user_id}/contacts/#{contact_id}", params: nil, headers: { authorization: "Token #{user_token}" }
    end

    context 'when the record exists' do
      it 'returns the contact' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(contact_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:contact_id) do
        100
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Contact/)
      end
    end
  end

  # Test suite for POST /users/:user_id/contacts
  describe 'POST /users/:user_id/contacts' do
    # valid payload
    let(:valid_attributes) do
      {firstname: 'Firstname', lastname: 'Lastname', email: 'test@test.com', user_id: user_id}
    end

    context 'when the request is valid' do
      before do
        post "/users/#{user_id}/contacts", params: valid_attributes, headers: { authorization: "Token #{user_token}" }
      end

      it 'creates a contact' do
        expect(json['firstname']).to eq('Firstname')
        expect(json['lastname']).to eq('Lastname')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before do
        post "/users/#{user_id}/contacts", params: {firstname: 'Firstname', lastname: 'Lastname', user_id: user_id}, headers: { authorization: "Token #{user_token}" }
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match(/Validation failed: Email can't be blank/)
      end
    end
  end

  # Test suite for PUT /users/:user_id/contacts/:id
  describe 'PUT /users/:user_id/contacts/:id' do
    let(:valid_attributes) do
      {firstname: 'Firstname New'}
    end

    context 'when the record exists' do
      before do
        put "/users/#{user_id}/contacts/#{contact_id}", params: valid_attributes, headers: { authorization: "Token #{user_token}" }
      end

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /users/:user_id/contacts/:id
  describe 'DELETE /users/:user_id/contacts/:id' do
    before do
      delete "/users/#{user_id}/contacts/#{contact_id}", headers: { authorization: "Token #{user_token}" }
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end