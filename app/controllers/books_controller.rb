class BooksController < ApplicationController
  # private参照、ログイン中のユーザーのみ編集・削除できるようにする
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book_show = Book.find(params[:id])
    @user = @book_show.user
    @book = Book.new
    @book_comment = BookComment.new

    # 閲覧数
    unless ReadCount.find_by(user_id: current_user.id, book_id: @book_show.id)
      current_user.read_counts.create(book_id: @book_show.id)
    end
  end
  
  def index
    @user = current_user
    @book = Book.new

    # ソート機能(最新、古い、スター)
    if params[:latest]
      @books = Book.latest
    elsif params[:old]
      @books = Book.old
    elsif params[:star_count]
      @books = Book.star_count
    else
      # リロードしたとき、いいねが多い順位に表示(過去1週間)
      to = Time.current.at_end_of_day             # 本日の23:59:59を toという変数に入れる
      from = (to - 6.day).at_beginning_of_day     # to の 6日前の 0:00を fromという変数に入れる
      @books = Book.all.sort {|a,b| 
        b.favorites.where(created_at: from...to).size <=> 
        a.favorites.where(created_at: from...to).size
      }
    end

    # page(params[:page])   適応方法分からず据え置き
  end

  def edit
    @book = Book.find(params[:id])
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book.id)
    else
      @user = current_user
      @books = Book.page(params[:page])
      render :index
    end
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
    redirect_to books_path
  end

  private

  # ログイン中のユーザーのみ編集・削除できるようにする
  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end

  def book_params
    params.require(:book).permit(:title, :body, :star, :tag)
  end
end
