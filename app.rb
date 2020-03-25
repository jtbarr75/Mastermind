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
    save(game)
    if params[:is_codemaker] == 'true'
      redirect '/ready'
    else
      session[:code] = game.computer.code
      redirect'/breaker'
    end
  end

  get '/ready' do
    game = Game.new(session)
    reset_db
    session[:next_guess] = game.computer.create_possible_codes.first
    create_possible_codes_db(game)
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
      remove_code_from_db(game.new_guess)
      session[:last_guess] = game.new_guess
      game.board.add(game.new_guess, game.turn)
    end

    erb :maker_show, :locals => game.view_variables
  end

  post '/maker' do
    game = Game.new(session)
    possible_codes = get_codes_from_db
    game.computer.possible_codes = Marshal.load(Marshal.dump(possible_codes)) #deep cloning the 2d array
    
    feedback = get_player_feedback
    game.computer.calculate(feedback)
    removed_codes = possible_codes - game.computer.possible_codes
    removed_codes.each do |code|
      remove_code_from_db(code)
    end

    session[:next_guess] = game.computer.possible_codes.first
    game.board.add_feedback(game.turn, feedback)
    game.turn = game.turn + 1
    save(game)
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
    save(game)
    redirect '/breaker'
  end

  post '/reset' do
    reset_db
    session.clear
    redirect '/'
  end

  def get_player_feedback
    feedback = []
    params[:num_correct].to_i.times {feedback.push("C")}
    params[:num_misplaced].to_i.times {feedback.push("/")}
    feedback.push("X") until feedback.length == session[:code_length]
    feedback
  end

  def reset_db
    Code.destroy_all if Code.first
  end

  def create_possible_codes_db(game)
    game.computer.create_possible_codes.each do |code|
      code = code.each_with_index.map { |value, index| ["color#{index}", value] }.to_h
      Code.create(code)
    end
  end

  def remove_code_from_db(code)
    c = Code.find_by(color0: code[0], 
                     color1: code[1],
                     color2: code[2],
                     color3: code[3],
                     color4: code[4],
                     color5: code[5])
    c.destroy if c
  end

  def get_codes_from_db
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
    possible_codes
  end

  def save(game)
    game.session_variables.each {|key, value| session[key] = value}
  end
end