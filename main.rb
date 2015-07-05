require 'rubygems'
require 'json'
require 'sinatra'
require 'data_mapper'
require 'twitter'
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
  params[:reg_twitter][:filename] = str_name
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

def name(surface, nubecita)
  if surface.length < 2
    surface = "0" + surface
  end
  str_name = surface + "_" + nubecita + "_" + Time.now.to_i.to_s
  return str_name
end

