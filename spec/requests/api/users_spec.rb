RSpec.describe 'Users API', type: :request do
  context 'User is not authorized' do
    context '#index' do
      subject do
        get '/api/users#index'
        JSON.parse(response.body)
      end
      specify { expect(subject).to include('errors' => 'Nil JSON web token') }
    end

    context '#show' do
      let!(:user) do
        User.create(name: "tanvin", handle: "tanvin", bio: "nice", email: "tanvin@toptal.com", password: "123", password_confirmation: "123")
      end
      subject do
        get "/api/users/#{user.id}"
        JSON.parse(response.body)
      end
      specify { expect(subject).to include('errors' => 'Nil JSON web token') }
    end

    context '#update' do
      let!(:user) do
        User.create(name: "tanvin", handle: "tanvin", bio: "nice", email: "tanvin@toptal.com", password: "123", password_confirmation: "123")
      end
      subject do
        get "/api/users/#{user.id}", params: { user: { name: 'AB' } }
        JSON.parse(response.body)
      end
      specify { expect(subject).to include('errors' => 'Nil JSON web token') }
    end

    context '#destroy' do
      let!(:user) do
        User.create(name: "tanvin", handle: "tanvin", bio: "nice", email: "tanvin@toptal.com", password: "123", password_confirmation: "123")
      end
      subject do
        delete "/api/users/#{user.id}"
        JSON.parse(response.body)
      end
      specify { expect(subject).to include('errors' => 'Nil JSON web token') }
    end
  end


  context 'User is authorized' do
    let!(:user) { User.create(name: "tanvin", handle: "tanvin", bio: "nice", email: "tanvin@toptal.com", password: "123", password_confirmation: "123") }
    let!(:token) { JsonWebToken.encode(user_id: user.id )}
    describe 'index' do
      subject(:api_response) do
        get "/api/users", headers: { "Authorization" => "#{token}" }
        response
      end

      specify { expect(api_response).to have_http_status(200) }
      specify { expect(JSON.parse(api_response.body).size).to eq(1) }

      context 'when have Users' do
        let!(:user) { User.create(name: "tanvin", handle: "tanvin123", bio: "nice", email: "tanvin123@toptal.com", password: "123", password_confirmation: "123") }

        specify do
          puts user.errors.full_messages
          expect(JSON.parse(api_response.body)).to match([
            hash_including({
              "name" => "tanvin",
              "handle" => "tanvin123",
              "bio" => "nice",
              "email" => "tanvin123@toptal.com",
              "id" => user.id
            })
          ])
        end
      end
    end

    describe 'create' do
      subject(:api_response) do 
        post "/api/users", params: params
        response
      end

      let(:params) do
        {
          user: {
            name: "tanvin12", handle: "tanvin12", bio: "nice", email: "tanvin12@toptal.com", password: "123", password_confirmation: "123"
          }
        }
      end

      specify { expect(api_response).to have_http_status(201) }
      specify do
        expect(JSON.parse(api_response.body)).to match(hash_including(
          "name" => "tanvin12",
          "handle" => "tanvin12",
          "bio" => "nice",
          "email" => "tanvin12@toptal.com",
          "tweets" => []
        ))
      end 

      specify { expect { api_response }.to change(User, :count).by(1) }
    end
    
    describe 'update' do    
      subject(:api_response) do
        patch "/api/users/#{user.id}", params: params, headers: { "Authorization" => "#{token}" }
        response
      end
      let(:user) { User.create(name: "test", handle: "test", bio: "test", email: "test@toptal.com", password: "123", password_confirmation: "123") }
      let(:params) do
        {
          user: {
            name: "tes", handle: "tes", bio: "tes", email: "tes@toptal.com", password: "123", password_confirmation: "123"
          }
        }
      end
    
      specify { expect(api_response).to have_http_status(200) }

      specify do
        expect(JSON.parse(api_response.body)).to match(hash_including(
          "name" => "tes",
          "handle" => "tes",
          "bio" => "tes",
          "email" => "tes@toptal.com",
          "id" => user.id,
          "tweets" => []
        ))
      end 
    end

    describe 'destroy' do
      subject(:api_response) do 
        delete "/api/users/#{user.id}", headers: { "Authorization" => "#{token}" }
        response
      end
      let!(:user) { User.create(name: "tanvin", handle: "tanvin", bio: "nice", email: "tanvin@toptal.com", password: "123", password_confirmation: "123") }
      
			specify { expect(api_response).to have_http_status(200) }
      specify do
        expect(JSON.parse(api_response.body)).to match(hash_including(
          "name" => "tanvin",
          "handle" => "tanvin",
          "bio" => "nice",
          "email" => "tanvin@toptal.com",
          "id" => user.id,
          "tweets" => []
        ))
      end
      
      specify { expect { api_response }.to change(User, :count).by(-1) }
    end
  end
end
