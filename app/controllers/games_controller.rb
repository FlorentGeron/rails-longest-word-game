class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
      # TODO: generate random grid of letters
    @letters = []
    10.times { @letters << ("A"..."Z").to_a[rand(25)] }
    @start_time = Time.now
    @letters
  end

  def score
    @attempt = params['input']
    @start_time2 = Time.parse(params['time'])
    @end_time = Time.now
    @grid = params['grid'].chars
    @result = { time: @end_time - @start_time2, score: 0 }
    if attempt_compliant?(@attempt, @grid) && attempt_in_dico?(@attempt)
      @result[:message] = "Well done, Champion!"
      @result[:score] = (@attempt.length * 1000) + 120 - (@end_time - @start_time2)
    else
      @result[:message] = attempt_compliant?(@attempt, @grid) ? "Do better (not an english word)" : "Do better (not in the grid)"
    end
    @result
  end

  def attempt_compliant?(attempt, grid)
    test_array = attempt.upcase.chars
    test_array.delete("")
    test_array.all? { |letter| test_array.count(letter) <= grid.count(letter) }
  end

  def attempt_in_dico?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    dico_answer = JSON.parse(URI.open(url).read)
    dico_answer["found"]
  end
end
