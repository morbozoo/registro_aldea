require 'data_mapper'
require 'pony'

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

##-----------------------DATABASE------------------------

@zoos = Reg_Mail.all(:sent => false)

# for item in @zoos
#   puts item[:message]
# end  



def send_mail
  Pony.mail({
    :to => 'amozoo@ciencias.unam.mx',
    :via => :smtp,
    :subject => 'hi',
    :headers => { 'Content-Type' => 'text/html' },
    :html_body => 'public/nube_1.html',
    :via_options => {
      :address              => 'smtp.infinitummail.com',
      :port                 => '465',
      :enable_starttls_auto => true,
      :user_name            => 'lanubedealdeadigital@infinitummail.com',
      :password             => 'Ald3aDigital.',
      :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
      :domain               => "infinitumzone.net" # the HELO domain provided by the client to the server
    }
  })
end

send_mail()