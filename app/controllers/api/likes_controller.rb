module Api
  class LikesController < ApplicationController
    def create
      @likes = Like.create(like_params)
      update_tweet(params[:tweet_id], true)
      if @likes.save
        render json: @likes, status: :created
      else
        render json: @likes.errors, status: :unprocessable_entity
      end
    end


    def destroy
      @like = Like.find(params[:id])
      @like.destroy
      update_tweet(@like.tweet_id, false)
    end

    private

    def like_params
      params.permit(:user_id, :tweet_id)
    end

    def update_tweet(tweet_id, create)
      tweet = Tweet.find(tweet_id)
      if create
        tweet.update(no_of_likes: tweet.no_of_likes + 1)
      else
        tweet.update(no_of_likes: tweet.no_of_likes - 1)
      end
    end
  end
end