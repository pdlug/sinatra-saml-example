# frozen_string_literal: true
require 'sinatra'
require 'ruby-saml'
require 'yaml'

SAMLUser = Struct.new(:username, :attributes)

class Server < Sinatra::Base
  set :root, File.expand_path('..', File.dirname(__FILE__))

  enable :sessions

  configure do
    cfg = YAML.load_file(File.expand_path('../config/app.yml',
                                          File.dirname(__FILE__)))

    saml_settings = OneLogin::RubySaml::Settings.new
    saml_settings.idp_entity_id = cfg[:issuer_url]
    saml_settings.idp_sso_target_url = cfg[:saml_endpoint]
    saml_settings.idp_slo_target_url = cfg[:slo_endpoint]
    saml_settings.idp_cert = cfg[:idp_cert]

    set :saml, saml_settings
  end

  get '/' do
    slim(:index)
  end

  get '/login' do
    request = OneLogin::RubySaml::Authrequest.new
    redirect(request.create(settings.saml), 302)
  end

  get '/logout' do
    session.clear
    redirect('/', 302)
  end

  post '/saml/recipient' do
    response = OneLogin::RubySaml::Response.new(
      params[:SAMLResponse], settings: settings.saml)
    halt 403, 'Invalid login' unless response.is_valid?

    session[:user] = SAMLUser.new(response.name_id, response.attributes)
    redirect('/', 302)
  end
end
