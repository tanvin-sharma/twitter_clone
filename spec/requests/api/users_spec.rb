RSpec.describe 'Users API', type: :request do
	describe 'GET' do
		subject(:result) do
			get '/api/users'
			response
		end

		it { is_expected.to have_http_status(200) }
		specify { expect(JSON.parse(result.body)).to eq([]) }

		context 'when has users' do
			let!(:user) { User.create(name: "Tanvin", bio: 'this is some bio', handle: "tanvin", email: "tanvin@test.com") }
			let(:json) { JSON.parse(result.body) }

			it { expect(json).not_to be_empty }

			it { expect(json).to match([hash_including("name" => "Tanvin", "bio" => 'this is some bio', "handle" => "tanvin", "email" => "tanvin@test.com")]) }
		end
	end

	describe 'GET' do 
		subject(:result) do 
			get "/api/users/#{user_id}"
			response
		end

		context 'user already exists' do 
			let!(:user) { User.create(name: "Tanvin", handle: "tanvin", email: 'tanvin@test.com')}
			let!(:user_id) { user.id }

			it { is_expected.to have_http_status(200) }

			it 'returns the user' do 
				expect(JSON.parse(result.body)['id']).to eq(user_id)
			end
		end

		context 'user doesnt exist' do 
			let(:user_id) { 5 }
			it {is_expected.to have_http_status(404)}

			it 'returns a not found message' do 
				expect(JSON.parse(result.body)).to eq("error"=> "Couldn't find User with 'id'=5")
			end
		end
	end

	describe 'POST' do 
		subject(:result) do
			post '/api/users', params: valid_params
			response
		end
		context 'request is valid' do
			let(:valid_params) { { name: 'tanvin', handle: 'tanvin', email: 'tanvin@test.com', bio: 'some nice bio' } }
			it { is_expected.to have_http_status(201) }

			it 'creates_user' do 
				expect { result }.to change(User, :count).by(1)
			end
		end
	end

	describe  'POST' do
		subject(:result) do
			post '/api/users', params: valid_params
			response
		end

		context 'request is valid' do
			let(:valid_params) { { name: "tanvin", handle: "tanvin", email: "tanvin", bio:'some nice bio' } }

			it { is_expected.to have_http_status(201) }

			it 'creates an user' do
				expect { result }.to change(User, :count).by(1)
			end
		end

		context 'request is invalid' do
			before { post '/api/users', params: {} }

			specify { expect(response).to have_http_status(422) }

			it 'returns a failure message' do
				expect(JSON.parse(response.body)).to match({
					"name"=>["can't be blank"],
					"handle"=>["can't be blank"],
					"email"=>["can't be blank"]
				}) 
			end
		end
	end

	describe 'DELETE' do
    let!(:user) { User.create(name: "tanvin", handle: "tanvin", email: "tanvin", bio:'some nice bio') }
    let!(:user_id) { User.all.first.id }

    before { delete "/api/users/#{user_id}" }

    specify { expect(response).to have_http_status(204) }
  end
end
