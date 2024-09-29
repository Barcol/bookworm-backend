class Book < ApplicationRecord
  has_many :readings

  validates :title, presence: true
end
