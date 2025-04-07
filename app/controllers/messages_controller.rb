class MessagesController < ApplicationController

  # showアクションとcreateアクションを実行する前に、ユーザーの認証（ログイン）を確認
  before_action :authenticate_user!, only: [:show, :create]

  # showアクションは、特定のユーザーの詳細ページを表示するため
  def show
    @user = User.find(params[:id])
    @no_layouts_serach = true                                   # このページでは検索機能を表示しないようにするため
    rooms = current_user.entries.pluck(:room_id)                # 現在のユーザーが参加しているすべてのルームのIDを取得
    entries = Entry.find_by(user_id: @user.id, room_id: rooms)  # 特定のユーザーと現在のユーザーの間で共有されているルームのエントリーを見つける

    # エントリーが存在する場合、関連するルームを@roomに代入
    unless entries.nil?
      @room = entries.room

    # エントリーが存在しない場合、新しいルームを作成し、保存し、お互いのエントリーを作成
    else
      @room = Room.new(user_id: current_user.id)
      @room.save
      Entry.create(user_id: current_user.id, room_id: @room.id)
      Entry.create(user_id: @user.id, room_id: @room.id)
    end

    # @roomに関連するメッセージを@messagesに、新しいメッセージを作成したものは@messageに代入
    @messages = @room.messages
    @message = Message.new(room_id: @room.id)
  end

  def create                                              # createアクションは、新しいメッセージを作成するため
    @message = current_user.messages.new(message_params)  # 現在のユーザーに関連付けられた新しいメッセージを作成
    @message.save
    redirect_to request.referer
  end

  private

  def message_params
    params.require(:message).permit(:message, :room_id)
  end

end