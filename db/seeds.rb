# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

%w(Arabic English Frensh German Hindi Italian Japanese Korean Portuguese Russian Spanish Turkish Ukrainian Urdu).each do |name|
  language = Language.find_or_create_by(name: name)
  (1..5).each{ |i| language.channels.find_or_create_by(name: "Channel##{i}") }
end

languages_ids = Language.pluck :id
channels_ids = Channel.pluck :id

(1..1000).each do |i|
  u = User.create_with(password: '12345678', password_confirmation: '12345678',
                       name: "User #{i}", username: "user.#{i}", points: 500,
                       last_active_at: Time.now, language_id: languages_ids.sample,
                       current_channels_ids: channels_ids.sample(5)).find_or_create_by(email: "user#{i}@native.com")
end

users_ids = User.pluck :id

User.all.each{ |u| u.update_attribute(:friends_ids, users_ids.sample(50))}