require_relative 'lib/mastermind'
require 'sinatra'
require 'sinatra/reloader'

configure do
  enable :sessions, :layout
end

get '/' do
  session[:game] = Mastermind.new unless session[:game]
  erb :index, :locals => session[:game].variables
end

post '/' do
  session[:game].create_game(params[:num_colors].to_i, params[:code_length].to_i, params[:is_codemaker])
  if params[:is_codemaker] == 'True'
    redirect '/ready'
  else
    redirect'/breaker'
  end
end

get '/ready' do
  erb :ready_show, :locals => session[:game].variables
end

post '/ready' do
  redirect '/maker'
end

get '/maker' do
  game = session[:game]
  game.new_guess = game.computer.guess
  game.board.add(game.new_guess, game.turn)
  erb :maker_show, :locals => session[:game].variables
end

post '/maker' do
  game = session[:game]
  feedback = get_player_feedback
  game.computer.calculate(feedback)
  game.board.add_feedback(game.turn, feedback)
  game.turn = game.turn + 1
  redirect '/maker'
end

get '/breaker' do
  erb :breaker_show, :locals => session[:game].variables
end

post '/breaker' do
  game = session[:game]
  guess = params.values
  feedback = game.computer.get_feedback(guess)
  game.board.add(guess, game.turn, feedback)
  game.turn = game.turn + 1
  redirect '/breaker'
end

post '/reset' do
  session[:game] = Game.new
  redirect '/'
end

def get_player_feedback
  game = session[:game]
  feedback = []
  params[:num_correct].to_i.times {feedback.push("C")}
  params[:num_misplaced].to_i.times {feedback.push("/")}
  feedback.push("X") until feedback.length == game.code_length
  feedback
end