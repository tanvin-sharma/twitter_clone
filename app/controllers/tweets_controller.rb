class TweetsController < ApplicationController
    def index
        @tweets = Tweet.all
        render "tweets/index"
    end
    
    def new

    end

    def create
        tweet = Tweet.create(content: params[:content])
        puts(tweet.errors.full_messages)
        redirect_to('/')
    end
end
