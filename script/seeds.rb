Profile.create :name => "alx", :email => "alx.girard@gmail.com"

a = Profile.first

a.questions.create(:text => "Sex")
a.questions.create(:text => "Sleep")
a.questions.create(:text => "Drinks")
a.questions.create(:text => "Hacking")
a.questions.create(:text => "Motivation")
a.questions.create(:text => "Dreams")
a.questions.create(:text => "Wake Up")
a.questions.create(:text => "Love")
a.questions.create(:text => "Health")

