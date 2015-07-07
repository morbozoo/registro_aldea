require 'data_mapper'
require 'twitter'
require 'RMagick'

##-----------------------CONSTANTS------------------------
msg_tw_0 = " se siente Enamorado "
msg_tw_1 = " se siente Radiante"
msg_tw_2 = " se siente Felíz"
msg_tw_3 = " se siente Sorprendido"
msg_tw_4 = " se siente Indiferente"
msg_tw_5 = " se siente Inteligente"
@mensajes = [msg_tw_0, msg_tw_1, msg_tw_2, msg_tw_3, msg_tw_4, msg_tw_5]

##-----------------------DATABASE------------------------
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class Reg_Mail
  include DataMapper::Resource
  property :id,           Serial
  property :surface_id,   String, :required => true
  property :nubecita,     Integer
  property :name,         String, :required => true
  property :message,      Text,   :required => true       
  property :mail_list,    Text
  property :sent,         Boolean, default: false
end
Reg_Mail.auto_upgrade!

class Reg_Twitter
  include DataMapper::Resource
  property :id,         Serial
  property :surface_id, String, :required => true
  property :nubecita,   Integer
  property :user_name,  String
  property :tweet,      String
  property :twitter_id, String
  property :filename,   String
  property :sent,       Boolean, default: false
end
Reg_Twitter.auto_upgrade!

DataMapper.finalize

##-----------------------TWITTER------------------------
@twitter_clients = []

client01 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "w4rHXOjzqTrBXQW6ZKnl77VCH"
  config.consumer_secret     = "bWfjcjvS2QZU6neDLkFe4iPdgCsFDV0ioY4vJyyHdqGWd4L0BC"
  config.access_token        = "3267267924-FDAk1R6ln7gD1la3uNmjDuutIm8yEzHKBSDCDU4"
  config.access_token_secret = "IeN3C1OKJUysjAXpmdvMkJzthg1vCnNr24fgncCiPa8N2"
end
@twitter_clients.push(client01)

client02 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "xpNaGPBqcof0yyrHtg7Ui97uA"
  config.consumer_secret     = "gWQinSnfGoKsyHdiaGAJxaRi1uyzCYvCJT3B7LOwRbxhDBc8h1"
  config.access_token        = "3267427993-WA8W9S5L1diX31UOzMMCyERec6w36YuPYL1qhNI"
  config.access_token_secret = "TURBhtDgKcOx6ad3D3FPMHsdBWAk4q3AWzlURSSt9r0N5"
end
@twitter_clients.push(client02)

client03 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "NQh0pGycwicBMRJiRx8V77Onh"
  config.consumer_secret     = "TVyeScpmHJ1YPMDpbKtqMt1vZq6tHJNN3ZZ6qAyXvnNX8rvGoy"
  config.access_token        = "3267346506-4fQzUddW8n9THWpDwEvp5P1cvD18ZtO1TUeVBkl"
  config.access_token_secret = "1PtVIntB3LJ7DNgd5NEqZSkDLOQsaUhD8Mkig6CXoyJOk"
end
@twitter_clients.push(client03)

client04 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "ZQmFJNTUook9WYDvdTDt6KT44"
  config.consumer_secret     = "MadNLggbhL7qNyRkwA3RB92uW55L4IYs27khc92KwnIVvahmzP"
  config.access_token        = "3267449953-KFo1wEpaeNJR0eMyxkQvPbi8DDEe6YHSfEjd13M"
  config.access_token_secret = "RZFZ3r4kZ9lgiTnpO8oH5aoSTCKZOStF2empNLzsbXgzk"
end
@twitter_clients.push(client04)

client05 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "7eL9MURKIlAtBGyvU5Tocx6xF"
  config.consumer_secret     = "fybQNF2WifUI8abJJp40HqlnlKK13OZNBU2VselWzepxxCSxh3"
  config.access_token        = "3267425732-MtCWcDneW8N48qwjbyhZRrNU5RbyyrKyx3V2O6x"
  config.access_token_secret = "PS00cqBgOBIwKD11RwbKLZ5bKsbI7E7rfmfrdYpwNGtiX"
end
@twitter_clients.push(client05)

client06 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "XC0lADgwPinqm4PHxS2WZgNqb"
  config.consumer_secret     = "S1K20KvSajD1KHIsIg53F50zO9GFzgHFEotfUicd3QvkZsDjcV"
  config.access_token        = "3267421608-dPb5FVvAEGyXKscxnelir9qbHrCRk6HtcdqwDcS"
  config.access_token_secret = "2LQloWlJJNsuAjlAc7OO4MZzKBEm9py3rn9KzlsAnuath"
end
@twitter_clients.push(client06)

client07 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "6yBlgdB0G0DZg5aLqSsF3Ovm5"
  config.consumer_secret     = "sD5zk3sK7yUPqDUiTeOHETM3iUYn8QyurtAd5Cftxt1VYcimEb"
  config.access_token        = "3267436958-WBniCJsmN19w2LtdgwjGyKHBgBT9LMzQG1EJdIF"
  config.access_token_secret = "yQOvoPVSQ3xM3eLBvu1l0p7U76gJrVxMjA75SJPImj6iC"
end
@twitter_clients.push(client07)

client08 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "agGyb2obgQDr1mOxPMsI5vw1p"
  config.consumer_secret     = "KzM4tJMviz1T2L0OweBptnPZKv6SFeknQBaJRKFsCEJK3rMpBt"
  config.access_token        = "3267489331-l6enWGsH6KT7t7BUUoZAbMQlelC4BOhxMjDbKC0"
  config.access_token_secret = "xv11P1e6AQAb6H3lJpk9Dbf9pRzt5s6BfTe212yg2j7Cz"
end
@twitter_clients.push(client08)

client09 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "yGlzqYgc7KtfV0Nudy4PEvJxZ"
  config.consumer_secret     = "05xvfDCXCkKgXpP15G7VidgdvL31rN8UAbu80a3oeNtL3QCM9s"
  config.access_token        = "3267446126-BA9BodEGI1YLwYKXXpKRolSy9LJ4whjFUPYlpC7"
  config.access_token_secret = "FBmOnWCnagV4N58Zg4fNCnEfkBBcPATQVhGzARNEe86jY"
end
@twitter_clients.push(client09)

client10 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "3MhBEx0fcETUeB1ZSti0DmJ4C"
  config.consumer_secret     = "YBKY26K4v0Z6mlI9ft2gQd7s2AhW6WS4Lz3P1Uqc9A2XlQDenC"
  config.access_token        = "3267456026-zgQCCH5vygPeSuLStYzokH35zTZe7yvRaRVy206"
  config.access_token_secret = "j2ta3BsqPBwZzU68NMbK3ElVeLJSB9IWlBjiluk6Mt2Qp"
end
@twitter_clients.push(client10)

client11 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "BVcdRSaO3nPflHxOhxpUoylaC"
  config.consumer_secret     = "8fPMm8ZPaMNS4DeDs9rtoTVcqRy7szfCYaNJtE1gHZI99u9snP"
  config.access_token        = "3267459506-K7chBvRe1LlS46MfMJcdqbHO1wO4e38HITsLp7R"
  config.access_token_secret = "BLQWMoJXaJiWS5GyqH6CXMYxB2D7tr49ayxeOTIi7ILii"
end
@twitter_clients.push(client11)

client12 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "Tn51d8EpZFM3DXlUeDBtpwpMb"
  config.consumer_secret     = "XpYSFtZs29KMbRTJCs3Lde43z2gRAv3wSQQmjBxXmVE0Vsu4fO"
  config.access_token        = "3267461168-Lyl93NRCcwy4Fu0qIMrIJARsl4tG3dptTjbKbl0"
  config.access_token_secret = "VAxX4qRjyNcy9BDN37lWbsKNRQ1OVvKLhO6TYbKANQzDd"
end
@twitter_clients.push(client12)

client13 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "oBVXYWsKnWByyev6kk0MW8zJY"
  config.consumer_secret     = "6wseTivVEiBNkYPL2KOcVQiVNAY1c8YvY0arQNdxxdZlxbD4hX"
  config.access_token        = "3267415044-GEalxvIab4TsZ9Wc7D38DHRwEt1g29rQeJuE4AH"
  config.access_token_secret = "SNIVbtBS7wrIbxCncAgZIj415JXMcN4z9QP2TL1C0hM1s"
end
@twitter_clients.push(client13)

client14 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "st5GnW1S4WgVjjiKQhmzFN9pH"
  config.consumer_secret     = "l9mCUEb1a5zQepy0CCiMeR17kBlhE3NCyyixqYCwbw8PJ6OXJS"
  config.access_token        = "3267514243-pbMIPV4MBYVeHRsNPovo1BsThyAmfO4R7zF3UK0"
  config.access_token_secret = "csoyqYWCIknPjnIbpcGNpCYQGDP7Q7ZUKfvgKFEtjGYOF"
end
@twitter_clients.push(client14)

client15 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "5zgLiMg43wXdfBHIOIzkyozHZ"
  config.consumer_secret     = "NOa6GzXWkBUroVvZP6TsD2TYp7r3RttAKIBckCdipbJm5WyUJe"
  config.access_token        = "3270294169-uDC0W1DEVv7XKm93kovt7vdHXGHu0S6Ez1ruT5w"
  config.access_token_secret = "brjrc9VdqagddyWbB2tC5RnclKvxmm2VEZn4m2kW1UhzY"
end
@twitter_clients.push(client15)

##-----------------------------------------------

def tweetear
  @to_tweet = Reg_Twitter.all(:sent => false)
  cont = 1
  for item in @to_tweet
    mensaje = @mensajes[item[:nubecita]]
    filename = item[:filename]
    crear_nube(item[:nubecita], item[:filename])
    @twitter_clients[cont].update_with_media(mensaje, File.new('photos/nube/' + filename + '.png'))
    item.update(:sent => true)
    puts "tweet enviado"
    cont = cont + 1
    puts cont
    if cont == 15
      cont = 1
    end
  end  
end

def crear_nube(nube, filename)
  dst = Magick::Image.read("public/images/nube_" + nube + ".png").first
  src = Magick::Image.read("/fotos/" + filename + ".png").first
  src_1 = src.resize(225, 225)
  result = dst.composite!(src_1, 250, 175, Magick::OverCompositeOp)
  result.write('photos/nube/' + filename + '.png')
end

while true
  sleep(100)
  puts "iniciando"
  tweetear()
end