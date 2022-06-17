RSpec.describe 'Tweets API', type: :request do
  let!(:user) { User.create(name: "tanvin", handle: "tanvin", email: "tanvin@test.com") }

  describe 'GET' do
    subject(:result) do
      get "/api/tweets"
      response
    end

    it { is_expected.to have_http_status(200)}
    specify { expect(JSON.parse(result.body)).to eq([]) }

    context 'tweets' do
      let!(:tweet) { user.tweets.create(content: "random content", no_of_likes: 2 )}

      it 'shows attributes' do
        expect(JSON.parse(result.body)[0]).to match(hash_including("content" => "random content", "no_of_likes"=> 2))
      end
    end
  end

  describe 'POST' do
    subject(:result) do 
      post "/api/tweets", params: valid_params
      response
    end

    context 'valid request' do
      let(:valid_params) { { content: "random content", user_id: user.id } }

      it { is_expected.to have_http_status(201) }

      it 'post tweet' do
        expect { result }.to change(Tweet, :count).by(1)
      end
    end

    context 'invalid request' do
      before { post '/api/tweets', params: {} }
      
      it { expect(response).to have_http_status(422) }

      it 'fail msg' do
        expect(JSON.parse(response.body)).to match({
          "content"=>["can't be blank"],
          "user"=>["must exist"],
        }) 
      end
    end
  end

  describe 'GET' do
    subject(:result) do
      get "/api/tweets/#{tweet_id}"
      response
    end

    context 'tweet exists' do
      let!(:tweet) { Tweet.create(content: 'random content', user_id: user.id) }
      let!(:tweet_id) { tweet.id }

      it { is_expected.to have_http_status(200) }

      it 'return tweet' do
        expect(JSON.parse(result.body)['id']).to eq(tweet_id)
      end
    end

    context 'tweet doesnt exist' do
      let!(:tweet_id) { 0 }

      it { is_expected.to have_http_status(404) }

      it 'not found msg' do 
        expect(JSON.parse(result.body)).to eq("error" => "Couldn't find Tweet with 'id'=0")
      end
    end
  end


  describe 'PUT' do
    let!(:tweet) { Tweet.create(content: 'random content', user_id: user.id) }
    let!(:tweet_id) { tweet.id }

    subject(:result) do
      put "/api/tweets/#{tweet_id}", params: { content: "edited" }
      response
    end

    context ' valid request' do
      it { is_expected.to have_http_status(200) }

      it 'updates tweet' do
        expect { result }.to change { tweet.reload.content }.from("random content").to("edited")
      end

      it 'updates response' do
        expect(JSON.parse(result.body)).to match(hash_including("content"=>"edited")) 
      end
    end

    context 'invalid request' do
      before { put "/api/tweets/#{tweet_id}", params: { content: "" }; response }

      specify { expect(response).to have_http_status(422) }

      it 'fail msg' do
        expect(JSON.parse(response.body)).to match({
          "content"=>["can't be blank"],
        }) 
      end
    end
  end

  describe 'DELETE' do
    let!(:tweet) { Tweet.create(content: 'random content', user_id: user.id) }
    let!(:tweet_id) { tweet.id }

    before { delete "/api/tweets/#{tweet_id}" }

    specify { expect(response).to have_http_status(204) }
  end
end