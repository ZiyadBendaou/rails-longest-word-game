class GamesController < ApplicationController
require 'open-uri'
require 'json'
  def new
    @letters = Array.new(10) { ("A".."Z").to_a.sample }
  end

  def score
    letters = params[:letters]
    guess = params[:guess].upcase

    if included?(guess, letters)
      if english_word?(guess)
        @result = "Congratulations! #{guess} is a valid English word!"
      else
        @result = "Sorry but #{guess} does not seem to be a valid English word..."
      end
    else
      letters = letters.gsub(/["\[\]]/, '')
      @result = "Sorry but #{guess} can't be built out of #{letters}"
    end
  end

  private

  def included?(word, grid)
    word.chars.all? { |c| word.count(c) <= grid.count(c) }
  end

  def english_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    word_serialized = URI.open(url).read
    response = JSON.parse(word_serialized)
    response["found"]
  end
end
