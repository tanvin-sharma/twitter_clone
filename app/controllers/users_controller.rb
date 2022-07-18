class UsersController < ApplicationController
    before_action :authorize_user, only: [:index, :show]
    def index
        @users = User.all
    end
    
    def show
        @user = User.find(params[:id])
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        puts @user.inspect
        
        if @user.save!
            session[:user_id] = @user.id
            redirect_to login_path, notice: "successfully created user account"
        else
            render :new, status: :unprocessable_entity
        end
    end

    def user_params
    params.require(:user).permit(:name, :handle, :bio, :email, :password, :password_confirmation)
    end

    def authorize_user
    unless logged_in?
      flash.alert = "Please log in."
      session[:redirected_from] = request.path
      redirect_to login_url
    end
  end
  
end
