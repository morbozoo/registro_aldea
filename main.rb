#!/usr/bin/ruby

require 'rubygems'
require 'json'
require 'sinatra'
require 'data_mapper'
require 'twitter'
require 'pony'
require 'rmagick'
require 'roadie'

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
  property :filename,     String
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

##-----------------------REQUEST HANDLERS------------------------ 
get '/' do
  File.read('public/nube_1.html')
end

post '/mail' do
  str_name = name(params[:reg_mail][:surface_id],params[:reg_mail][:nubecita])
  upload_photo(params, str_name)
  circle_photo(str_name)
  params[:reg_mail][:filename] = str_name
  Reg_Mail.create  params[:reg_mail]
  content_type :json
  { :surface_id => params[:reg_mail][:surface_id], :name => params[:reg_mail][:name] }.to_json
end

post '/twitter' do
  str_name = name(params[:reg_twitter][:surface_id],params[:reg_twitter][:nubecita])
  upload_photo(params, str_name)
  circle_photo(str_name)
  params[:reg_twitter][:filename] = str_name
  Reg_Twitter.create  params[:reg_twitter]
  content_type :json
  { :surface_id => params[:reg_twitter][:surface_id]}.to_json
end

post '/nube_aldea' do
  @filename = params[:file][:filename]
  str_name = name(params[:surface_id],params[:nubecita])
  upload_photo(params, str_name)
  circle_photo(str_name)
  content_type :json
  { :surface_id => params[:surface_id], :nubecita => params[:nubecita]}.to_json
end  

##-----------------------AUXILIAR METHODS------------------------ 

def upload_photo(params, str_name)
  file = params[:file][:tempfile]
  File.open("./photos/" + str_name + ".png", 'wb') do |f|
    f.write(file.read)
  end
end

def circle_photo(name)
  im = Magick::Image.read('photos/' + name + '.png').first
  circle = Magick::Image.new 640, 360
  gc = Magick::Draw.new
  gc.fill 'black'
  gc.circle 320, 180, 320, 5
  gc.draw circle
  mask = circle.blur_image(0,1).negate
  mask.matte = false
  im.matte = true
  im.composite!(mask, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)
  chopped = im.crop(125, 3, 400, 400)
  mirrored = chopped.flop
  mirrored.write '/fotos/' + name + '.png'
end

def name(surface, nubecita)
  if surface.length < 2
    surface = "0" + surface
  end
  str_name = surface + "_" + nubecita + "_" + Time.now.to_i.to_s
  return str_name
end

