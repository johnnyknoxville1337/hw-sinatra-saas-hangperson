require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'
require 'sinatra'

class MyApp < Sinatra::Base
  get '/' do
    "<!DOCTYPE html><html><head></head><body><h1>Hello Wöald</h1></body></html>"
  end
end

class HangpersonApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || HangpersonGame.new('')
  end
  
  after do
    session[:game] = @game
  end
  
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || HangpersonGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = HangpersonGame.new(word)
    redirect '/show'
  end
  
  # Use existing methods in HangpersonGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    if params[:guess].to_s[0] =~ /[[:alpha:]]/
      letter = params[:guess].to_s[0]
    if @game.guesses.include? letter or @game.wrong_guesses.include? letter
      flash[:message] = "You have already used that letter."
    else
      @game.guess(letter)
    end
    else
    flash[:message] = "Invalid guess."
    end
    redirect '/show'
  end
  
  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in HangpersonGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    ### YOUR CODE HERE ###
    if @game.check_win_or_lose == :win then redirect '/win'
    elsif @game.check_win_or_lose == :lose then redirect '/lose'
    else erb :show end # You may change/remove this line
  end
  
  get '/win' do
    ### YOUR CODE HERE ###
    if @game.check_win_or_lose == :win then erb :win
  else redirect '/show' end
  end
  
  get '/lose' do
    ### YOUR CODE HERE ###
    if @game.check_win_or_lose == :lose then erb :lose
    else redirect '/show' end
  end
  
end
