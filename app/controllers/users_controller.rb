class UsersController < ApplicationController

  before_filter :signed_in_user, 
                only: [:index, :edit, :update, :following, :followers]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def show
    @user = User.find(params[:id])
    @scrawls = @user.scrawls.paginate(page: params[:page])
  end

  def new
      @user = User.new
  end

  def create
      @user = User.new(params[:user])
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to Scrawl!"
        redirect_to @user
      else
        render 'new'
      end
  end

  def destroy
    @user = User.find(params[:id])
    if !current_user.admin?
      @user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    else
      flash[:error] = "Can't delete admin."
      redirect_to users_path
    end
  end

  def index
    @users = User.all
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.all
    render 'show_following'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.all
    render 'show_followers'
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
end
