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
  session[:game].create_game(params[:num_colors].to_i, params[:code_length].to_i, params[:is_codemaker])
  if params[:is_codemaker] == 'True'
    redirect '/maker'
  else
    redirect'/breaker'
  end
end

get '/maker' do
  erb :maker_show, :locals => session[:game].variables
end

get '/breaker' do
  erb :breaker_show, :locals => session[:game].variables
end

post '/reset' do
  session[:game] = Game.new
  redirect '/'
end