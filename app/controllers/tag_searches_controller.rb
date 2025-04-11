class TagSearchesController < ApplicationController
  def search
    @model = Book   # viewのタイトルで使用
    @range = "tag"  # viewの判定に使用
    @word = params[:word]
    @books = Book.where("tag LIKE?","%#{@word}%")
    render "tag_searches/tag_result"
  end
end
