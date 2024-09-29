class Reading < ApplicationRecord
  belongs_to :book
  validates :start_date, presence: true
end
