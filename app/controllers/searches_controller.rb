class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]

    if @range == "User"
      @users = User.looks(params[:search], params[:word]).page(params[:page])
    else
      @books = Book.looks(params[:search], params[:word]).page(params[:page])
    end
  end
end