require 'rails_helper'

RSpec.describe "Readings", type: :request do
  let!(:example_book) { Book.create(title: "Example Book") } # TODO add factorybot

  describe 'POST /books/:book_id/readings/:id' do
    subject { post book_readings_path(example_book), params: params }

    context 'with valid parameters' do
      let(:params) { { reading: { start_date: 3.days.ago, start_page: 213 } } }
      it 'creates a new reading' do
        expect { subject }.to change { example_book.readings.count }.by(1)
      end

      it 'returns the reading' do
        subject
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include('start_page' => 213)
      end
    end

  end

  describe "PUT /books/:book_id/readings/:id" do
    subject { put book_reading_path(example_book, reading), params: params }

    let!(:reading) { Reading.create(book: example_book, start_date: 3.days.ago, start_page: 21) }

    context 'with valid parameters' do
      let(:params) { { reading: { end_date: Date.today, end_page: 37 } } }

      it 'updates the reading' do
        expect { subject }.to change { reading.reload.end_page }.from(nil).to(37).
        and change{ reading.reload.end_date }.from(nil).to(anything)
      end
    end
  end
end
