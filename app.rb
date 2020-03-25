require_relative 'lib/game'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require_relative 'models/code'

class App < Sinatra::Base

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
    session[:next_guess] = game.computer.create_possible_codes.first
    game.computer.create_possible_codes.each do |code|
      code = code.each_with_index.map { |value, index| ["color#{index}", value] }.to_h
      Code.create(code)
    end
    erb :ready_show, :locals => game.view_variables
  end

  post '/ready' do
    redirect '/maker'
  end

  get '/maker' do
    game = Game.new(session)
    game.new_guess = session[:next_guess]
    game.computer.last_guess = session[:next_guess]

    if game.new_guess
      c = Code.find_by(color0: game.new_guess[0], 
                      color1: game.new_guess[1],
                      color2: game.new_guess[2],
                      color3: game.new_guess[3],
                      color4: game.new_guess[4],
                      color5: game.new_guess[5])
      c.destroy
      session[:last_guess] = game.new_guess
      game.board.add(game.new_guess, game.turn)
    end

    erb :maker_show, :locals => game.view_variables
  end

  post '/maker' do
    game = Game.new(session)
    possible_codes = []
    Code.find_each do |code|
      c = [code.color0, 
           code.color1,
           code.color2,
           code.color3,
           code.color4,
           code.color5].compact
      possible_codes.push(c)
    end
    
    game.computer.possible_codes = Marshal.load(Marshal.dump(possible_codes)) #deep cloning the 2d array
    feedback = get_player_feedback
    game.computer.calculate(feedback)
    removed_codes = possible_codes - game.computer.possible_codes
    removed_codes.each do |code|
      c = Code.find_by(color0: code[0], 
                       color1: code[1],
                       color2: code[2],
                       color3: code[3],
                       color4: code[4],
                       color5: code[5])
      c.destroy
    end

    session[:next_guess] = game.computer.possible_codes.first
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
    Code.destroy_all
    redirect '/'
  end

  def get_player_feedback
    feedback = []
    params[:num_correct].to_i.times {feedback.push("C")}
    params[:num_misplaced].to_i.times {feedback.push("/")}
    feedback.push("X") until feedback.length == session[:code_length]
    feedback
  end

end