# coding: utf-8

require 'discordrb'
require 'nokogiri'
require 'open-uri'
require 'uri'

def translate_en_to_jp(word_en)
  # (1) 英単語の単語ItemIdを取得
  enc_word = URI.encode(word_en)
  url = "http://public.dejizo.jp/NetDicV09.asmx/SearchDicItemLite?Dic=EJdict&Word=#{enc_word}&Scope=HEADWORD&Match=EXACT&Merge=OR&Prof=XHTML&PageSize=20&PageIndex=0"
  xml = open(url).read
  doc = Nokogiri::XML(xml)
  item_id = doc.search('ItemID').first.inner_text rescue nil
  return nil unless item_id
  # (2)英単語のItemIdから翻訳を取得
  url = "http://public.dejizo.jp/NetDicV09.asmx/GetDicItemLite?Dic=EJdict&Item=#{item_id}&Loc=&Prof=XHTML"
  xml = open(url).read
  doc = Nokogiri::XML(xml)
  text = doc.search('Body').inner_text rescue nil
  text.gsub!(/(\r\n|\r|\n|\t|\s)/, '')
  return text
end

def translate_jp_to_en(word_jp)
  # 日本語単語のItemIdを取得
  enc_word = URI.encode(word_jp)
  url = "http://public.dejizo.jp/NetDicV09.asmx/SearchDicItemLite?Dic=EdictJE&Word=#{enc_word}&Scope=HEADWORD&Match=EXACT&Merge=OR&Prof=XHTML&PageSize=20&PageIndex=0"
  xml = open(url).read
  doc = Nokogiri::XML(xml)
  item_id = doc.search('ItemID').first.inner_text rescue nil
  return item_id unless item_id
  # 日本語単語のItemIdから英単語を取得
  url = "http://public.dejizo.jp/NetDicV09.asmx/GetDicItemLite?Dic=EdictJE&Item=#{item_id}&Loc=&Prof=XHTML"
  xml = open(url).read
  doc = Nokogiri::XML(xml)
  text = doc.search('Body').inner_text rescue nil
  text.gsub!(/(\r\n|\r|\n|\t|\s)/, '')
  return text
end

bot = Discordrb::Commands::CommandBot.new(
  token: ENV['WEEABOT_TOKEN'],
  client_id: ENV['WEEABOT_CLIENT_ID'],
  prefix: '!'
)

bot.command :yes do |_event|
  'Yeeeessssss?'
end

bot.command :english do |_event, *args|
  translate_en_to_jp args.first
end

bot.command :japanese do |_event, *args|
  translate_jp_to_en args.first
end

bot.run
