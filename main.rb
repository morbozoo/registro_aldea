require 'rubygems'
require 'json'
require 'sinatra'
require 'data_mapper'
require 'slim'
require 'haml'
require 'twitter'
require 'omniauth-twitter'
require 'pony'
require 'rmagick'
require 'premailer'
require 'fog'

##-----------------------RACKSPACE------------------------
@storage = Fog::Storage.new(
  :provider => 'rackspace',
  :rackspace_username => 'kristian.tapia',
  :rackspace_api_key => 'c9f1d86e4c5648fbbef9d78efbfa0c8d',
  :rackspace_region => 'ord',
  :rackspace_temp_url_key => 'jnRB6#1sduo8YGUF&%7r7guf6f'
)
@storage.directories.all
directory = @storage.directories.create(:key => 'aldeaDigital')
directory.public = true
directory.save
account = @storage.account
account.meta_temp_url_key = 'jnRB6#1sduo8YGUF&%7r7guf6f'
account.save
# puts "public URL for #{file} is #{file.public_url}"
##-----------------------CONSTANTS------------------------
msg_tw_0 = "mensaje 0 enamorado"
msg_tw_1 = "mensaje 1 radiante"
msg_tw_2 = "mensaje 2 felíz"
msg_tw_3 = "mensaje 3 sorprendido"
msg_tw_4 = "mensaje 4 indiferente"
msg_tw_5 = "mensaje 5 inteligente"

##-----------------------TWITTER------------------------
use OmniAuth::Builder do
  provider :twitter, 'EFrlZBlXavNhAuMFFnWTfZiyJ', '0dA1Dc4o0tZMag1CJwFJ1bnmFE2m3PmjHqjgSKe8yY5CBeNlSt'
end

client01 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "w4rHXOjzqTrBXQW6ZKnl77VCH"
  config.consumer_secret     = "bWfjcjvS2QZU6neDLkFe4iPdgCsFDV0ioY4vJyyHdqGWd4L0BC"
  config.access_token        = "3267267924-FDAk1R6ln7gD1la3uNmjDuutIm8yEzHKBSDCDU4"
  config.access_token_secret = "IeN3C1OKJUysjAXpmdvMkJzthg1vCnNr24fgncCiPa8N2"
end

client02 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "xpNaGPBqcof0yyrHtg7Ui97uA"
  config.consumer_secret     = "gWQinSnfGoKsyHdiaGAJxaRi1uyzCYvCJT3B7LOwRbxhDBc8h1"
  config.access_token        = "3267427993-WA8W9S5L1diX31UOzMMCyERec6w36YuPYL1qhNI"
  config.access_token_secret = "TURBhtDgKcOx6ad3D3FPMHsdBWAk4q3AWzlURSSt9r0N5"
end

client03 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "NQh0pGycwicBMRJiRx8V77Onh"
  config.consumer_secret     = "TVyeScpmHJ1YPMDpbKtqMt1vZq6tHJNN3ZZ6qAyXvnNX8rvGoy"
  config.access_token        = "3267346506-4fQzUddW8n9THWpDwEvp5P1cvD18ZtO1TUeVBkl"
  config.access_token_secret = "1PtVIntB3LJ7DNgd5NEqZSkDLOQsaUhD8Mkig6CXoyJOk"
end

client04 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "ZQmFJNTUook9WYDvdTDt6KT44"
  config.consumer_secret     = "MadNLggbhL7qNyRkwA3RB92uW55L4IYs27khc92KwnIVvahmzP"
  config.access_token        = "3267449953-KFo1wEpaeNJR0eMyxkQvPbi8DDEe6YHSfEjd13M"
  config.access_token_secret = "RZFZ3r4kZ9lgiTnpO8oH5aoSTCKZOStF2empNLzsbXgzk"
end

client05 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "7eL9MURKIlAtBGyvU5Tocx6xF"
  config.consumer_secret     = "fybQNF2WifUI8abJJp40HqlnlKK13OZNBU2VselWzepxxCSxh3"
  config.access_token        = "3267425732-MtCWcDneW8N48qwjbyhZRrNU5RbyyrKyx3V2O6x"
  config.access_token_secret = "PS00cqBgOBIwKD11RwbKLZ5bKsbI7E7rfmfrdYpwNGtiX"
end

client06 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "XC0lADgwPinqm4PHxS2WZgNqb"
  config.consumer_secret     = "S1K20KvSajD1KHIsIg53F50zO9GFzgHFEotfUicd3QvkZsDjcV"
  config.access_token        = "3267421608-dPb5FVvAEGyXKscxnelir9qbHrCRk6HtcdqwDcS"
  config.access_token_secret = "2LQloWlJJNsuAjlAc7OO4MZzKBEm9py3rn9KzlsAnuath"
end

client07 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "6yBlgdB0G0DZg5aLqSsF3Ovm5"
  config.consumer_secret     = "sD5zk3sK7yUPqDUiTeOHETM3iUYn8QyurtAd5Cftxt1VYcimEb"
  config.access_token        = "3267436958-WBniCJsmN19w2LtdgwjGyKHBgBT9LMzQG1EJdIF"
  config.access_token_secret = "yQOvoPVSQ3xM3eLBvu1l0p7U76gJrVxMjA75SJPImj6iC"
end

client08 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "agGyb2obgQDr1mOxPMsI5vw1p"
  config.consumer_secret     = "KzM4tJMviz1T2L0OweBptnPZKv6SFeknQBaJRKFsCEJK3rMpBt"
  config.access_token        = "3267489331-l6enWGsH6KT7t7BUUoZAbMQlelC4BOhxMjDbKC0"
  config.access_token_secret = "xv11P1e6AQAb6H3lJpk9Dbf9pRzt5s6BfTe212yg2j7Cz"
end

client09 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "yGlzqYgc7KtfV0Nudy4PEvJxZ"
  config.consumer_secret     = "05xvfDCXCkKgXpP15G7VidgdvL31rN8UAbu80a3oeNtL3QCM9s"
  config.access_token        = "3267446126-BA9BodEGI1YLwYKXXpKRolSy9LJ4whjFUPYlpC7"
  config.access_token_secret = "FBmOnWCnagV4N58Zg4fNCnEfkBBcPATQVhGzARNEe86jY"
end

client10 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "3MhBEx0fcETUeB1ZSti0DmJ4C"
  config.consumer_secret     = "YBKY26K4v0Z6mlI9ft2gQd7s2AhW6WS4Lz3P1Uqc9A2XlQDenC"
  config.access_token        = "3267456026-zgQCCH5vygPeSuLStYzokH35zTZe7yvRaRVy206"
  config.access_token_secret = "j2ta3BsqPBwZzU68NMbK3ElVeLJSB9IWlBjiluk6Mt2Qp"
end

client11 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "BVcdRSaO3nPflHxOhxpUoylaC"
  config.consumer_secret     = "8fPMm8ZPaMNS4DeDs9rtoTVcqRy7szfCYaNJtE1gHZI99u9snP"
  config.access_token        = "3267459506-K7chBvRe1LlS46MfMJcdqbHO1wO4e38HITsLp7R"
  config.access_token_secret = "BLQWMoJXaJiWS5GyqH6CXMYxB2D7tr49ayxeOTIi7ILii"
end

client12 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "Tn51d8EpZFM3DXlUeDBtpwpMb"
  config.consumer_secret     = "XpYSFtZs29KMbRTJCs3Lde43z2gRAv3wSQQmjBxXmVE0Vsu4fO"
  config.access_token        = "3267461168-Lyl93NRCcwy4Fu0qIMrIJARsl4tG3dptTjbKbl0"
  config.access_token_secret = "VAxX4qRjyNcy9BDN37lWbsKNRQ1OVvKLhO6TYbKANQzDd"
end

client13 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "oBVXYWsKnWByyev6kk0MW8zJY"
  config.consumer_secret     = "6wseTivVEiBNkYPL2KOcVQiVNAY1c8YvY0arQNdxxdZlxbD4hX"
  config.access_token        = "3267415044-GEalxvIab4TsZ9Wc7D38DHRwEt1g29rQeJuE4AH"
  config.access_token_secret = "SNIVbtBS7wrIbxCncAgZIj415JXMcN4z9QP2TL1C0hM1s"
end

client14 = Twitter::REST::Client.new do |config|
  config.consumer_key        = "st5GnW1S4WgVjjiKQhmzFN9pH"
  config.consumer_secret     = "l9mCUEb1a5zQepy0CCiMeR17kBlhE3NCyyixqYCwbw8PJ6OXJS"
  config.access_token        = "3267514243-pbMIPV4MBYVeHRsNPovo1BsThyAmfO4R7zF3UK0"
  config.access_token_secret = "csoyqYWCIknPjnIbpcGNpCYQGDP7Q7ZUKfvgKFEtjGYOF"
end

client15 = Twitter::REST::Client.new do |config|
  config.consumer_key        = ""
  config.consumer_secret     = ""
  config.access_token        = ""
  config.access_token_secret = ""
end
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
  property :surface_id,    String, :required => true
  property :nubecita,   Integer
  property :user_name,  String
  property :tweet,      String
  property :twitter_id, String
  property :sent,       Boolean, default: false
end
Reg_Twitter.auto_upgrade!

DataMapper.finalize

##-----------------------REQUEST HANDLERS------------------------ 
get '/' do
  File.read('public/nube_1.html')
end

post '/mail' do
  str_name = name(params[:reg_mail][:surface_id],params[:reg_mail][:nubecita])
  upload_photo(params, str_name)
  circle_photo(str_name)
  Reg_Mail.create  params[:reg_mail]
  fork do
    file = directory.files.create key: File.basename('/fotos/' + str_name + '.png'),
                                body: File.open('/fotos/' + str_name + '.png', 'r')
    @storage = Fog::Storage.new(
      :provider => 'rackspace',
      :rackspace_username => 'kristian.tapia',
      :rackspace_api_key => 'c9f1d86e4c5648fbbef9d78efbfa0c8d',
      :rackspace_region => 'ord',
      :rackspace_temp_url_key => 'jnRB6#1sduo8YGUF&%7r7guf6f'
    )
    dir = @storage.directories.get('aldeaDigital')
    fil = dir.files.get('' + str_name + '.png')
    fil.public_url
    #handler.send_mail(params, str_name)
  end
  content_type :json
  { :surface_id => params[:reg_mail][:surface_id], :name => params[:reg_mail][:name] }.to_json
end

post '/twitter' do
  str_name = name(params[:reg_twitter][:surface_id],params[:reg_twitter][:nubecita])
  upload_photo(params, str_name)
  circle_photo(str_name)
  Reg_Twitter.create  params[:reg_twitter]
  @twit_surface = params[:reg_twitter][:surface_id]
  @twit_photo = params[:file][:filename]
  #client.update_with_media(msg, File.new("/fotos" + str_name + ".png"))
end

post '/nube_aldea' do
  @filename = params[:file][:filename]
  str_name = name(params[:surface_id],params[:nubecita])
  upload_photo(params, str_name)
  circle_photo(str_name)
end  

##-----------------------SESSIONS------------------------
configure do
  enable :sessions
end
 
helpers do
  def admin?
    session[:admin]
  end
end
 
get '/login' do
  redirect to("/auth/twitter")
end

get '/auth/twitter/callback' do
  env['omniauth.auth'] ? session[:admin] = true : halt(401,'Not Authorized')
  "You are now logged in"
end

get '/auth/failure' do
  params[:message]
end

##-----------------------AUXILIAR METHODS------------------------ 

def upload_photo(params, str_name)
  file = params[:file][:tempfile]
  File.open("./photos/" + str_name + ".png", 'wb') do |f|
    f.write(file.read)
  end
end

def send_mail(params, str_name)
  Pony.mail({
    :to => params[:reg_mail][:mail_list],
    :via => :smtp,
    :subject => 'hi',
    :headers => { 'Content-Type' => 'text/html' },
    :html_body => 'public/nube_1.html',
    :via_options => {
      :address              => 'smtp.gmail.com',
      :port                 => '587',
      :enable_starttls_auto => true,
      :user_name            => 'amozoo@ciencias.unam.mx',
      :password             => 'L4p4l0m@',
      :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
      :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
    }
  })
end

def circle_photo(name)
  im = Magick::Image.read('photos/' + name + '.png').first
  circle = Magick::Image.new 640, 480
  gc = Magick::Draw.new
  gc.fill 'black'
  gc.circle 310, 240, 310, 45
  gc.draw circle
  mask = circle.blur_image(0,1).negate
  mask.matte = false
  im.matte = true
  im.composite!(mask, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)
  chopped = im.crop(110, 40, 400,400)
  chopped.write '/fotos/' + name + '.png'
end

def premail(str_name)
  premailer = Premailer.new('public/temp' + str_name + '.html', :warn_level => Premailer::Warnings::SAFE)
  File.open("public/" + str_name + ".html", "w") do |fout|
    fout.puts premailer.to_inline_css
  end

  premailer.warnings.each do |w|
    puts "#{w[:message]} (#{w[:level]}) may not render properly in #{w[:clients]}"
  end
end

def name(surface, nubecita)
  if surface.length < 2
    surface = "0" + surface
  end
  str_name = surface + "_" + nubecita + "_" + Time.now.to_i.to_s
  return str_name
end

