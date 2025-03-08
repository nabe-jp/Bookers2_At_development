class BooksController < ApplicationController

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to books_path
    else
      @user = current_user
      @books = Book.page(params[:page])
      render :index
    end
  end

  def show
    @user = current_user
    @books = Book.page(params[:page])
    @book = Book.new
  end
  
  def index
    @user = current_user
    @books = Book.page(params[:page])
    @book = Book.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book.id)
    else
      render :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to user_path(current_user.id)
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

end
