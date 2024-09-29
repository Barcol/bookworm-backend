class ReadingsController < ApplicationController
  before_action :set_reading, only: [:update]
  before_action :set_book, only: [:create]

  # POST /readings
  def create
    @reading = Reading.new(reading_params.merge(book: @book))

    if @reading.save
      render json: @reading, status: :created
    else
      render json: @reading.errors, status: :unprocessable_entity
    end
  end

  # PUT /readings/1
  def update
    if @reading.update(reading_params)
      render json: @reading
    else
      render json: @reading.errors, status: :unprocessable_entity
    end
  end

  private

  def set_reading
    @reading = Reading.find(params[:id])
  end

  def set_book
    @book = Book.find(params[:book_id])
  end

  # Only allow a list of trusted parameters through.
  def reading_params
    params.require(:reading).permit(:book_id, :start_date, :start_page, :end_date, :end_page)
  end
end
