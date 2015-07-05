require 'data_mapper'
require 'pony'
require 'fog'

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

DataMapper.finalize

##-----------------------RACKSPACE------------------------


##-----------------------HTML STRINGS------------------------

str_1 = "<table  width=\"595\"
        height=\"777\" 
        style=\"background-color: white;\"
        text-align=\"center\">
  <tr height=\"150\">
    <td align=\"center\">
        <img src=\"https://72f7ed2ed9a20d512140-172f54d3400a9a3a895a0038338de347.ssl.cf2.rackcdn.com/email/logo_aldea.png\">
    </td>
  </tr>
  <tr>
    <td>
      <table  background=\""

str_2 = "\"
              width=\"595\">
        <tr height=\"130\">
          <td width=\"28\"></td>
          <td>
            <font face=\"helvetica\" size=\"5\" color=\"white\">¡Hola!</font>
          </td>
        </tr>
        <tr height=\"60\">
          <td width=\"28\"></td>
          <td width=\"550\"><font face=\"helvetica\" size=\"5\" color=\"white\">"

str_3 = "quiere compartirte como se siente hoy en Aldea Digital
          </font></td>
        </tr>
        <tr height=\"102\">
          <td></td>
        </tr>
        <tr  height=\"145\">
          <td width=\"28\"></td>
          <td>
            <table>
              <tr>
                <td width=\"208\"></td>
                <td>
                  <img  src=\""

str_4 = "\"
                        height=\"145\"
                        width=\"145\"
                        alt=\"Tu foto en Aldea Digital 2015\"> 
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr  height=\"100\">
          <td></td>
        </tr>
        <tr  height=\"60\">
          <td width=\"28\"></td>
          <td width=\"150\"></td>
          <td width=\"50\"><img src=\"http://72f7ed2ed9a20d512140-172f54d3400a9a3a895a0038338de347.r79.cf2.rackcdn.com/email/instagram.png\"></td>
          <td width=\"50\"><img src=\"http://72f7ed2ed9a20d512140-172f54d3400a9a3a895a0038338de347.r79.cf2.rackcdn.com/email/twitter.png\"></td>
          <td width=\"50\"><img src=\"http://72f7ed2ed9a20d512140-172f54d3400a9a3a895a0038338de347.r79.cf2.rackcdn.com/email/facebook.png\"></td>
        </tr>
      </table>
    </td>
  </tr>
</table>"

  ##-----------------------AUXILIAR METHODS------------------------
def get_nube(nubecita)
  case nubecita
    when 0
      str_nube = "https://72f7ed2ed9a20d512140-172f54d3400a9a3a895a0038338de347.ssl.cf2.rackcdn.com/email/enamorado.png"
    when 1
      str_nube = "https://72f7ed2ed9a20d512140-172f54d3400a9a3a895a0038338de347.ssl.cf2.rackcdn.com/email/feliz.png"
    when 2
      str_nube = "https://72f7ed2ed9a20d512140-172f54d3400a9a3a895a0038338de347.ssl.cf2.rackcdn.com/email/indiferente.png"
    when 3
      str_nube = "https://72f7ed2ed9a20d512140-172f54d3400a9a3a895a0038338de347.ssl.cf2.rackcdn.com/email/inteligente.png"
    when 4
      str_nube = "https://72f7ed2ed9a20d512140-172f54d3400a9a3a895a0038338de347.ssl.cf2.rackcdn.com/email/radiante.png"
    when 5
      str_nube = "https://72f7ed2ed9a20d512140-172f54d3400a9a3a895a0038338de347.ssl.cf2.rackcdn.com/email/sorprendido.png"
  end
  return str_nube
end

def store_photo(str_name)
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
    return fil.public_url
end

def name(surface, nubecita)
  if surface.length < 2
    surface = "0" + surface
  end
  str_name = surface + "_" + nubecita + "_" + Time.now.to_i.to_s
  return str_name
end

def send_mail(mail_list, final_string)
  Pony.mail({
    :to => "amozoo@ciencias.unam.mx",
    :via => :smtp,
    :subject => 'hi',
    :headers => { 'Content-Type' => 'text/html' },
    :html_body => final_string,
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


##-----------------------MAILER------------------------
@to_mail = Reg_Mail.all(:sent => false)
for item in @to_mail
  nube      = item[:nubecita]
  str_name  = item[:filename]
  name      = item[:name]
  mail_list = item[:mail_list]
  str_nube  = get_nube(nube)
  str_url   = store_photo(str_name)
  final_string = str_1 + str_nube + str_2 + name + str_3 + str_url + str_4
  send_mail(mail_list, final_string)
  puts "uno enviado"
end