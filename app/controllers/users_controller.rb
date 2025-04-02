class UsersController < ApplicationController
  # アクセスを制限を始めに実行
  before_action :is_matching_login_user, only: [:edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @book = Book.new
    @books = @user.books.page(params[:page])
    @type = "show"                   #非同期通信用
  end

  def index
    @user = current_user
    @book = Book.new
    @users = User.page(params[:page])
    @type = "index"                 #非同期通信用
  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user
      render :edit
    else
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "You have updated user successfully."
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  private
  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  # アクセスを制限
  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to user_path(current_user)
    end
  end
end