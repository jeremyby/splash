
require 'sinatra/base'
require "sinatra/activerecord"
require 'rack-flash'
require 'geoip'
require 'i18n'
require './contact'


class Splash < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  enable :sessions
  use Rack::Flash, :sweep => true
  
  set :database_file, "database.yml"
  
  I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'locales', '*.yml').to_s]

  Geoip = GeoIP.new("GeoIP.dat")
  
  helpers do
    def t(token)
      I18n.t(token)
    end
  end
  
  before do
    info = Geoip.country(request.env["REMOTE_ADDR"])
    # info = Geoip.country('124.79.38.211')
    
    I18n.locale = %w(cn hk tw sg mo).include?(info.country_code2.downcase) ? 'zh' : 'en'
  end
  
  get '/' do
    @contact = Contact.new
    haml :index, format: :html5
  end
  
  post '/contact' do
    contact = Contact.new(params[:contact])
    
    if contact.save
      flash[:notice] = 'Submission Successful. Thank you.'
    else
      flash[:notice] = "Email #{contact.errors.messages[:email].first}. Please try again."
      # flash[:notice] = 'Fail. Something went wrong. Please try again.'
    end
    
    redirect to('/')
  end
end