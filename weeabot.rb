require 'discordrb'

bot = Discordrb::Bot.new(
  token: ENV['WEEABOT_TOKEN'],
  client_id: ENV['WEEABOT_CLIENT_ID']
)

puts "This bot's invite URL is #{bot.invite_url}."
puts 'Click on it to invite it to your server.'

bot.message(content: 'Hi') do |event|
  event.respond 'Yeeeessssss?'
end

bot.run
