class BooksController < ApplicationController
  # GET /books
  def index
    @books = Book.all
    render json: @books, include: [:readings]
  end

  # GET /books/1
  def show
    @book = Book.find(params[:id])
    render json: @book
  end

  # POST /books
  def create
    @book = Book.new(book_params)

    if @book.save
      render json: @book, status: :created, location: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  private
     def book_params
      params.require(:book).permit(:title)
    end
end
