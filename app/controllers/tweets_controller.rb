class TweetsController < ApplicationController
  def index
    @tweets = Tweet.all
    render "tweets/index"
  end
  
  def new
  end

  def create
    tweet = Tweet.create(content: params[:content]) # REVIEW: user here should be taken from authentication
    puts(tweet.errors.full_messages) # REVIEW: This should be added to the page, not to the logs
    redirect_to('/')
  end
end
