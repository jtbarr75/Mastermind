require_relative 'lib/game'
require 'sinatra'
require 'sinatra/reloader'

configure do
  enable :sessions, :layout
end

get '/' do
  erb :index
end

post '/' do
  game = Game.new(params)
  game.session_variables.each {|key, value| session[key] = value}
  if params[:is_codemaker] == 'true'
    redirect '/ready'
  else
    session[:code] = game.computer.code
    redirect'/breaker'
  end
end

get '/ready' do
  game = Game.new(session)
  erb :ready_show, :locals => game.view_variables
end

post '/ready' do
  redirect '/maker'
end

get '/maker' do
  game = Game.new(session)
  game.new_guess = game.computer.guess
  game.board.add(game.new_guess, game.turn)
  erb :maker_show, :locals => game.view_variables
end

post '/maker' do
  game = Game.new(session)
  feedback = get_player_feedback
  game.computer.calculate(feedback)
  game.board.add_feedback(game.turn, feedback)
  game.turn = game.turn + 1
  game.session_variables.each {|key, value| session[key] = value}
  redirect '/maker'
end

get '/breaker' do
  game = Game.new(session)
  erb :breaker_show, :locals => game.view_variables
end

post '/breaker' do
  game = Game.new(session)
  guess = params.values
  feedback = game.computer.get_feedback(guess)
  game.board.add(guess, game.turn, feedback)
  game.turn = game.turn + 1
  game.session_variables.each {|key, value| session[key] = value}
  redirect '/breaker'
end

post '/reset' do
  redirect '/'
end

def get_player_feedback
  feedback = []
  params[:num_correct].to_i.times {feedback.push("C")}
  params[:num_misplaced].to_i.times {feedback.push("/")}
  feedback.push("X") until feedback.length == session[:code_length]
  feedback
end