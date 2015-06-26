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

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "EFrlZBlXavNhAuMFFnWTfZiyJ"
  config.consumer_secret     = "0dA1Dc4o0tZMag1CJwFJ1bnmFE2m3PmjHqjgSKe8yY5CBeNlSt"
  config.access_token        = "987369914-6FavTBBn5dFUy2F3mvc1yqYD6N3hGGb15DzDkzrC"
  config.access_token_secret = "lApFxTI06UwxMbeuRAWd0TWZUjAy9PJ6em50b55zyUNj4"
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
  property :sent,       Boolean, default: false
end
Reg_Twitter.auto_upgrade!

DataMapper.finalize

##-----------------------REQUEST HANDLERS------------------------ 
get '/' do
  File.read('public/nube_1.html')
end

post '/mail' do
  handler = Handlers.new
  handler.upload_photo(params, "mail")
  @filename = params[:file][:filename]
  str_name = params[:reg_mail][:surface_id] + "_" + params[:reg_mail][:nubecita] + "_" + Time.now.to_i.to_s
  handler.circle_photo("./photos/#{@filename}", str_name)
  Reg_Mail.create  params[:reg_mail]
  handler.send_mail(params, str_name)
  content_type :json
  { :surface => params[:reg_mail][:surface_id], 
    :nombre => params[:reg_mail][:name] }.to_json
end

post '/twitter' do
  handler = Handlers.new
  handler.upload_photo(params, "twitter")
  @filename = params[:file][:filename]
  str_name = params[:reg_twitter][:surface_id] + "_" + params[:reg_twitter][:nubecita] + "_" + Time.now.to_i.to_s
  handler.circle_photo("./photos/#{@filename}", str_name)
  Reg_Twitter.create  params[:reg_twitter]
  @twit_surface = params[:reg_twitter][:surface_id]
  @twit_photo = params[:file][:filename]
  #client.update_with_media(msg, File.new("/fotos" + str_name + ".png"))
  content_type :json
  { :surface => params[:reg_twitter][:surface_id], 
    :tweet => params[:reg_twitter][:tweet] }.to_json
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
class Handlers
  def upload_photo(params, wich)
    if wich == "twitter"
      @surface = params[:reg_twitter][:surface]
    else
      @surface = params[:reg_mail][:surface]
    end

    @filename = params[:file][:filename]
    file = params[:file][:tempfile]
    File.open("./photos/#{@filename}", 'wb') do |f|
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

  def circle_photo(photo, str_name)
    im = Magick::Image.read(photo).first
    circle = Magick::Image.new 200, 200
    gc = Magick::Draw.new
    gc.fill 'black'
    gc.circle 100, 100, 100, 1
    gc.draw circle
    mask = circle.blur_image(0,1).negate
    mask.matte = false
    im.matte = true
    im.composite!(mask, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)
    im.write '/fotos/' + str_name + '.png'
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

end
