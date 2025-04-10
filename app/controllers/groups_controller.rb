class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  
  def new
    @group = Group.new
  end

  def index
    @book = Book.new
    @groups = Group.all
    @user = User.find(current_user.id)
  end

  def show
    @book = Book.new
    @group = Group.find(params[:id])
    @user = User.find(@group.owner_id)  # useinfoをグループオーナーに変更
  end

  def edit
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @group.users << current_user    # @group.usersに、current_userを追加、グループ作成者がメンバーに含まれる
    if @group.save
      redirect_to groups_path
    else
      render 'new'
    end
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render "edit"
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_path
  end

  # メール機能に使用
  def new_mail
    @group = Group.find(params[:group_id])
  end
  
  # グループのメンバー全員にメールを送信するためのアクション
  def send_mail
    @group = Group.find(params[:group_id])
    group_users = @group.users
    @mail_title = params[:mail_title]
    @mail_content = params[:mail_content]
    # ContactMailer.send_mail(@group, @mail_title, @mail_content,group_users).deliver
  end

  
  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

  # 他人のグループの編集や削除を行えないようにする
  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end