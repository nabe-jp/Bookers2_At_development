class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    if (params[:range] == "User") || (params[:range] == "Book")
      @range = params[:range]
    else
      @range = "Tag"
    end
    @word = params[:word]

    if @range == "User"
      @type = "index" 
      @users = User.looks(params[:search], params[:word]).page(params[:page])
    elsif @range == "Book"
      @books = Book.looks(params[:search], params[:word]).page(params[:page])
    elsif @range == "Tag"
      @books = Book.where("tag LIKE?","%#{@word}%").page(params[:page])
    else
      flash[:alert] = "エラー"
    end
    render "searches/result"
  end
end