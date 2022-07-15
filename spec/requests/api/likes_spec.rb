RSpec.describe 'Likes API', type: :request do
  let!(:user1) { User.create(name: "tanvin", handle: "tanvin", email: "tanvin@test.com") }
  let!(:tweet) { user1.tweets.create(content: 'this is some content') }

  # REVIEW: Add tests for all database changes (Like.count and tweet.no_of_likes) for both requests
  describe 'POST' do
    subject(:result) do 
      post "/api/likes", params: valid_params
      response
    end
    context 'creating like' do
      let(:valid_params) { { user_id: user1.id, tweet_id: tweet.id } }

      it { is_expected.to have_http_status(201) }

      it 'post like' do
        expect { result }.to change{tweet.reload.no_of_likes}.by(1)
      end
    end
  end

  describe 'DELETE' do
    let!(:like) { Like.create(tweet_id: tweet.id, user_id: user1.id) }

    before { delete "/api/likes/#{like.id}" }

    specify { expect(response).to have_http_status(204) }
  end
end
