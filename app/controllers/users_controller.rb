class UsersController < ApplicationController
  
  #before_filter :signed_in_user, only: [:index, :edit, :update, :show]
  #before_filter :correct_user,   only: [:edit, :update, :show]

  def index
    @users = User.all
    #@users = User.paginate(page: params[:page])
  end


  def show
    @user = User.find(params[:id])
    #@videos = @user.videos.paginate(page: params[:page], :per_page => 4)
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def create
    #@user = User.new(user_params)
    @user = User.new(params[:user]) 
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to VSL-o-ROR!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end
    
    def correct_user
      @user = User.where(email: :email,password: :password)
      redirect_to(root_url) unless current_user?(@user)
    end
end
