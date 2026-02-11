class BooksController < ApplicationController

  # GET /books
  def index
    @books = Book.includes(:borrower).all

    render json: @books
  end

  # GET /books/1
  def show
    @book = Book.includes(:current_borrower, :active_borrowing, borrowings: :user).find(params[:id])
    render json: @book.as_json(include_history: true)
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

  # POST /books/1/borrow
  def borrow
    @book = Book.find(params[:id])
    @user = User.find(params[:user_id])

    if @book.borrowed_status
      render json: { error: 'Book is already borrowed' }, status: :unprocessable_entity
    else
      @book.update(borrowed_status: true)
      Borrowing.create(book_id: @book.id, user_id: @user.id, borrowed_at: Time.current, due_date: 30.days.from_now)
      render json: @book
    end
  end
  
  # POST /books/1/return_book
  def return_book
    @book = Book.find(params[:id])
    if @book.borrowed_status
      @borrowing = Borrowing.find_by(book_id: @book.id, returned_at: nil)
      if @borrowing.nil?
        @book.update(borrowed_status: false)
        render json: { error: 'Book is not currently borrowed' }, status: :unprocessable_entity
        return
      end
      @book.update(borrowed_status: false)
      @borrowing.update(returned_at: Time.current)

      render json: @book
    else
      render json: { error: 'Book is not currently borrowed' }, status: :unprocessable_entity
    end
  end

  # DELETE /books/1
  def destroy
    @book = Book.find(params[:id])
    @book.destroy
  end

  private
    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:serial, :title, :author, :borrowed_by)
    end
end
