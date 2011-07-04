class Profile
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String
  property :email,      String
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :name, :email

  has n, :questions, :through => Resource
  has n, :answers

  def formatted_output
    output = {:label => [], :values => []}
    values = {}
    self.questions.each do |question|
      output[:label] << question.text
      values[question.text] = []
    end

    min_date = Answer.min(:created_at)
    max_date = Answer.max(:created_at)

    date = Date.parse(min_date.strftime("%Y-%m-%d"))

    while(date < (max_date + 1))
      today = date.strftime("%Y-%m-%d")
      tomorrow = (date + 1).strftime("%Y-%m-%d")

      answers = self.answers.all(:conditions => ["created_at >= ? AND created_at < ?", today, tomorrow])

      if answers.size == output[:label].size
        output[:values] << {
          :label => today,
          :values => answers.map{|answer| answer.value.to_i}.to_a
        }
      end
      date += 1
    end

    return output
  end

end
