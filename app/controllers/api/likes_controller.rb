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

    # REVIEW: instead of all these, we may use counter_cache
    # https://guides.rubyonrails.org/association_basics.html#options-for-belongs-to-counter-cache
    def update_tweet(tweet_id, create)
      tweet = Tweet.find(tweet_id) # REVIEW: better lock the tweet before updating this. We will discuss that next week probably ;)
      if create
        tweet.update(no_of_likes: tweet.no_of_likes + 1)
      else
        tweet.update(no_of_likes: tweet.no_of_likes - 1)
      end
    end
  end
end
