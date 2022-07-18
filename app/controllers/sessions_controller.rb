class SessionsController < ApplicationController
  def new 
  end

  def create
    puts params
    # Add downcase & strip to email to remove accidental capitals & spaces
    user = User.find_by(email: params[:session][:email].downcase.strip)
    if user.present? && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Logged in successfully'
    else
      flash.now[:alert] = 'Invalid email or password'
      render :new
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged Out'
  end
end
# class SessionsController < ApplicationController
#   def new 
#   end

#   def create
#     user = User.find_by(email: params[:session][:email].downcase)
#     if user&.authenticate(params[:session][:password])
#       log_in user
#       flash[:alert] = "Welcome back, #{user.name}"
#       redirect_to(session[:intended_url] || user)
#       session[:intended_url] = nil
#     else
#       flash[:alert] = 'Invalid credentials'
#       render 'new', status: :unprocessable_entity
#     end
#   end

#   def destroy
#     log_out
#     redirect_to root_url
#   end

# end 