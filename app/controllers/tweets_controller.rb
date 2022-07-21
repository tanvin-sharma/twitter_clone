class TweetsController < ApplicationController
  before_action :authorize_user, only: [:create, :new]
  def index
    @tweets = Tweet.all
    render "tweets/index"
  end
  
  def new
    
  end
  
  def create
    @tweet = @current_user.tweets.new(content: params[:content])
    if @tweet.save
      flash[:notice] = "tweet created"
      redirect_to root_path
    else
      flash.now[:alert] = @tweet.errors.full_messages
      render 'new'
    end
  end
  
  private
  
  def authorize_user
    unless logged_in?
      flash.alert = "Please log in."
      session[:redirected_from] = request.path
      redirect_to login_url
    end
  end
end
