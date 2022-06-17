RSpec.describe 'Comments API', type: :request do
  let!(:user1) { User.create(name: "tanvin", handle: "tanvin", email: "tanvin@test.com") }
  let!(:tweet) { user1.tweets.create(content: 'this is some content') }

  describe 'POST' do
    subject(:result) do 
      post "/api/comments", params: valid_params
      response
    end

    context 'creating comment' do
      let(:valid_params) { { content: "random content", user_id: user1.id, tweet_id: tweet.id } }

      it { is_expected.to have_http_status(201) }

      it 'post tweet' do
        expect { result }.to change(Comment, :count).by(1)
      end
    end

    context 'creating invalid comment' do
      let(:valid_params) { { content: "random content", user_id: user1.id+2, tweet_id: tweet.id } }

      it { is_expected.to have_http_status(422) }

      it 'post tweet' do
        expect { result }.to change(Comment, :count).by(0)
      end
    end
  end

  describe 'PUT /api/comments/:id' do
    subject(:result) do 
      put "/api/comments/#{comment.id}", params: valid_params
      response
    end

    let!(:comment) { Comment.create(content: 'comment content', user_id: user1.id, tweet_id: tweet.id) }

    context 'updating comment' do
      let(:valid_params) { { content: "random content", user_id: user1.id, tweet_id: tweet.id } }

      it { is_expected.to have_http_status(200) }

      it 'updates the comment' do
        expect { result }.to change { comment.reload.content }.from("comment content").to("random content")
      end
      it 'updates the response' do
        expect(JSON.parse(result.body)).to match(hash_including("content"=>"random content")) 
      end
    end

    # REVIEW: invalid params missing
  end

  describe 'DELETE' do
    let!(:comment) { Comment.create(content: 'some content', user_id: user1.id) }
    let!(:comment_id) { tweet.id }

    before { delete "/api/tweets/#{comment_id}" }

    specify { expect(response).to have_http_status(204) }
  end
end
