require 'rails_helper'

RSpec.describe "Books", type: :request do
  describe "GET /books" do
    context 'there are books with readings created' do
      let(:example_title) { "Example Book" }
      let(:example_start_date) { 3.days.ago }
      let(:example_end_date) { Date.today }
      let(:example_start_page) { 4 }
      let(:example_end_page) { 17 }
      let!(:example_book) { Book.create(title: example_title,
                                        readings: [Reading.new(start_date: example_start_date,
                                                               start_page: example_start_page,
                                                               end_date: example_end_date,
                                                               end_page: example_end_page)]) }

      before do
        5.times do |i|
          book = Book.create(title: "Book #{i}")
          book.readings.create(start_date: 2.days.ago,
                               start_page: 0,
                               end_date: Date.today,
                               end_page: 15)
        end
      end

      it "returns all books along with their readings" do
        get books_path

        expect(response).to have_http_status(200)

        response_body = JSON.parse(response.body)
        expect(response_body.count).to eq(6)
        expect(response_body).to include a_hash_including(
                                           "title" => example_title,
                                           "readings" => include(a_hash_including(
                                                                   "start_page" => example_start_page,
                                                                   "final_details" => a_hash_including(
                                                                     "end_date" => be_a(String),
                                                                     "end_page" => example_end_page
                                                                   )
                                                                 )
                                           )
                                         )

      end
    end

    context 'there are no books to return' do
      it 'returns an empty array' do
        get books_path

        expect(response).to have_http_status(200)

        response_body = JSON.parse(response.body)
        expect(response_body).to eq([])
      end
    end
  end
  describe "GET /book" do
    context 'there is existing book with a reading associated' do
      let(:example_title) { "Example Book" }
      let(:example_start_date) { 3.days.ago }
      let(:example_end_date) { Date.today }
      let(:example_start_page) { 4 }
      let(:example_end_page) { 17 }
      let!(:example_book) { Book.create(title: example_title,
                                        readings: [Reading.new(start_date: example_start_date,
                                                               start_page: example_start_page,
                                                               end_date: example_end_date,
                                                               end_page: example_end_page)]) }
      it 'returns a single book with its readings' do
        get book_path(example_book.id)

        expect(response).to have_http_status(200)

        response_body = JSON.parse(response.body)

        expect(response_body).to include(
          "title" => example_title,
          "readings" => include(a_hash_including(
                                  "start_page" => example_start_page,
                                  "final_details" => a_hash_including(
                                    "end_date" => be_a(String),
                                    "end_page" => example_end_page
                                  )
                                )
          )
                                 )
      end
    end

    context 'requested book does not exist' do
      it 'returns a 404' do
        get book_path(-1)

        expect(response).to have_http_status(404)
      end
    end
  end

  describe "POST /books" do
    subject { post books_path, params: { book: { title: book_title } } }

    context 'with valid parameters' do
      let(:book_title) { "New Book" }

      it 'creates a new book' do
        expect { subject }.to change { Book.count }.by(1)
      end

      it 'returns the created book' do
        subject

        expect(response).to have_http_status(201)

        response_body = JSON.parse(response.body)
        expect(response_body).to include("title" => book_title)
      end
    end

    context 'with invalid parameters' do
      let(:book_title) { "" }

      it 'does not create a new book' do
        expect { subject }.not_to change { Book.count }
      end

      it 'returns an error response' do
        subject

        expect(response).to have_http_status(422)

        response_body = JSON.parse(response.body)
        expect(response_body).to include("title" => ["can't be blank"])
      end
    end
  end
end
