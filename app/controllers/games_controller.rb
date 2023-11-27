require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    alphabet = ("A".."Z").to_a
    @letters = []
    10.times do
      @letters << alphabet.sample
    end
  end

  def valid_grid?
    grid = Array.new(@letters)
    @word.chars.each do |char|
      if grid.include?(char)
        grid.delete_at(grid.index(char))
      else
        return false
      end
    end
    return true
  end

  def add_score
    if @score
      session[:score] += @word.length
    else
      session[:score] = @word.length
    end
    @score = session[:score]
  end

  def score
    session[:score] ? @score = session[:score] : 0
    @answer = ""
    if params[:word] && params[:letters]
      @letters = params[:letters].chars
      @word = params[:word].upcase
      if valid_grid?
        url = "https://wagon-dictionary.herokuapp.com/#{@word}"
        response = URI.open(url).read
        response = JSON.parse(response)
        if response["found"]
          @answer = "Congratulations! #{@word} is valid!"
          add_score
        else
          @answer = "Sorry but #{@word} is not a valid english word!"
        end
      else
        @answer = "Sorry but #{@word} can't be built out of #{@letters.join(", ")}!"
      end
    end
  end
end
