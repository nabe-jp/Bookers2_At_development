class RelationshipsController < ApplicationController
  
  # フォローするとき
  def create
    current_user.follow(params[:user_id])
    @user = User.find(params[:user_id])         #非同期通信時使用
    @type = params[:param]                      #非同期通信時使用

    if(@type == "show")
      redirect_to request.referer               #DM機能の為、同期通信
    else
      render :relationships_users_index_table   #非同期通信時使用
    end
  end

  # フォロー外すとき
  def destroy
    current_user.unfollow(params[:user_id])
    @user = User.find(params[:user_id])       #非同期通信時使用
    @type = params[:param]                    #非同期通信時使用

    if(@type == "show")
      redirect_to request.referer               #DM機能の為、同期通信
    else
      render :relationships_users_index_table   #非同期通信時使用
    end
  end

  # フォロー一覧
  def followings
    @user = User.find(params[:user_id])
    @users = @user.followings.page(params[:page])
  end
  
  # フォロワー一覧
  def followers
    @user = User.find(params[:user_id])
    @users = @user.followers.page(params[:page])
  end
end