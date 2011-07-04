class Answer
  include DataMapper::Resource

  property :id,         Serial
  property :value,      String
  property :created_at, DateTime

  validates_presence_of :value

  belongs_to :question
  belongs_to :profile
end

