require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'slim'
require 'haml'
require 'twitter'
require 'omniauth-twitter'

use OmniAuth::Builder do
  provider :twitter, 'EFrlZBlXavNhAuMFFnWTfZiyJ', '0dA1Dc4o0tZMag1CJwFJ1bnmFE2m3PmjHqjgSKe8yY5CBeNlSt'
end

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "EFrlZBlXavNhAuMFFnWTfZiyJ"
  config.consumer_secret     = "0dA1Dc4o0tZMag1CJwFJ1bnmFE2m3PmjHqjgSKe8yY5CBeNlSt"
  config.access_token        = "987369914-6FavTBBn5dFUy2F3mvc1yqYD6N3hGGb15DzDkzrC"
  config.access_token_secret = "lApFxTI06UwxMbeuRAWd0TWZUjAy9PJ6em50b55zyUNj4"
end

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class Reg_Mail
  include DataMapper::Resource
  property :id,       Serial
  property :photo_id, Integer, :required => true
  property :name,     String
  property :message,  Text
  property :mails,    Text
  property :sent,     Boolean, default: false
end
Reg_Mail.auto_upgrade!

class Reg_Twitter
  include DataMapper::Resource
  property :id,       Serial
  property :photo_id, String, :required => true
  property :surface,  String, :required => true
  property :sent,     Boolean, default: false
end
Reg_Twitter.auto_upgrade!

DataMapper.finalize
 
get '/' do
  @reg_mails = Reg_Mail.all
  slim :index
end

post '/mail' do
  Reg_Mail.create  params[:reg_mail]
  redirect to('/')
end

post '/twitter' do
  Reg_Twitter.create  params[:reg_twitter]
  @twit_surface = params[:reg_twitter][:surface]
  @twit_photo = params[:reg_twitter][:photo_id]
  client.update_with_media("pruebas", File.new("photos/surface_#{@twit_surface}/#{@twit_photo}"))
end

get '/twitter' do
  @cola_twitter = Reg_Twitter.all(:limit => 10, :verified => false, :in_verification => false)
  slim :twitter_verification
end

# Handle GET-request (Show the upload form)
get "/upload" do
  haml :upload
end      
    
# Handle POST-request (Receive and save the uploaded file)
post "/upload" do 
  @filename = params[:file][:filename]
  file = params[:file][:tempfile]
  @surface = params[:surface]
 
  File.open("./photos/surface_#{@surface}/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end
end




configure do
  enable :sessions
end
 
helpers do
  def admin?
    session[:admin]
  end
end
 
get '/public' do
  "This is the public page - everybody is welcome!"
end
 
get '/private' do
  halt(401,'Not Authorized') unless admin?
  "This is the private page - members only"
end
 
get '/login' do
  redirect to("/auth/twitter")
end

get '/twitter_post' do
  client.update_with_media("pruebas", File.new("photos/surface_9/photo.jpg"))
end

get '/auth/twitter/callback' do
  env['omniauth.auth'] ? session[:admin] = true : halt(401,'Not Authorized')
  "You are now logged in"
end

get '/auth/failure' do
  params[:message]
end
 
get '/logout' do
  session[:admin] = nil
  "You are now logged out"
end
