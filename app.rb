require_relative 'lib/game'
require 'sinatra'
require 'sinatra/reloader'

configure do
  enable :sessions
end

get '/' do
  session[:game] = Game.new unless session[:game]
  erb :index, :locals => session[:game].variables
end

post '/' do
  if session[:game].started 
    
  else
    session[:game].started = true
    session[:game].create_game(params[:num_colors].to_i, params[:code_length].to_i, params[:is_codemaker])
  end
    redirect '/'
end