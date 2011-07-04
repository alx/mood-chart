require 'rubygems'
require 'jabber/bot'

load File.join(File.dirname(__FILE__), "../environment.rb")

config = YAML.load_file(File.join(File.dirname(__FILE__), "bot_config.yml"))

# Create a new bot
bot = Jabber::Bot.new({
  :name      => 'MoodChart Bot',
  :jabber_id => config['bot']['login'],
  :password  => config['bot']['password'],
  :master    => ["alx.girard@gmail.com"],
  :is_public => true,
  :status    => 'Hello, I am your MoodChart bot.',
  :presence  => :chat,
  :priority  => 10,
  :silent    => true,
  :debug     => true
})

bot.add_command(
  :syntax      => 'moods',
  :description => 'lists questions, with order for answering',
  :regex       => /^moods$/
) do |sender, message|
  questions = ""
  profile = Profile.first(:email => sender)

  profile.questions.each do |question|
    questions += question.text + " "
  end # questions

  "Answer in this order: " + questions
end

bot.add_command(
  :syntax       => 'moods answers',
  :description  => 'answer the question',
  :regex        => /^moods.*$/,
  :full_message => true
) do |sender, message|
  command, answer = message.split(" ")

  profile = Profile.first(:email => sender)
  questions = profile.questions.reverse

  answers = message.gsub(/^moods\s+/, '').split(/\s+/)

  if(answers.size != questions.size)
    output = "incorrect number of answers, please verify"
  else
    answers.each do |answer|
      if question = questions.pop
        Answer.create! :value => answer,
                       :question => question,
                       :profile => profile,
                       :created_at => Time.now
      end # questions.pop
    end # answer.each
    output = "stats registered for today"
  end # answers.size != questions.size

  output
end # add_command

bot.connect
