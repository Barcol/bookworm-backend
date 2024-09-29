class BookSerializer < ActiveModel::Serializer
  attributes :id, :title

  has_many :readings, serializer: ReadingSerializer
end
