class Question
  include DataMapper::Resource

  property :id,         Serial
  property :text,       String  
  property :created_at, DateTime

  validates_presence_of :text

  has n, :answers
end
