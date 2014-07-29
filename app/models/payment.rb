class Payment
  include MongoMapper::Document

  belongs_to :donor
  belongs_to :campaign
  key :amount,  Float,  required: true
  key :time,    Time,   required: true
end
