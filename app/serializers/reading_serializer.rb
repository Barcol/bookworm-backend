class ReadingSerializer < ActiveModel::Serializer
  attributes :id, :start_date, :start_page, :final_details

  def start_date
    object.start_date
  end
  def final_details
    {end_date: object.end_date, end_page: object.end_page}
  end
end
