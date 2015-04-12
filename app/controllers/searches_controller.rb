class SearchesController < ApplicationController
  @search

  def index
  end

  def show

  end

  def new

  end

  def create
    Indico.api_key = 'f921ed87f664b65b825d7fe1e86dfcab'
    @ticker = params[:q]
    stocks = StockQuote::Stock.quote(@ticker)
    @name = stocks.name
    @price = stocks.ask
    #need to get rid of the Inc, and CORP
    #render text: "#{ticker} #{name} #{stocks.success?}"
    #stock = stocks[0]
    #@search = Search.new(ticker, stocks)
    #render text: "#{search.ticker}"

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "VmfQOxNEMgUCb00IKbP9CQqcH"
      config.consumer_secret     = "sZEPGSiXmEGpbkz6iLK7mjofJNWbnkYaMrjrZoBmvbW0X1Bo2F"
      config.access_token        = "321584017-v2hkNhY3Ydv0jpxVB8IAEdmiZ3zZFYfGrCV03BSu"
      config.access_token_secret = "tsV1WdVKCa4O46rJRLuxKOuSy3GT3pQ2GKTfKtnukwEAu"
    end

    @tweets_from_ticker = []
    @tweets_from_at_name = []
    @tweets_from_hashtag_name = []

    client.search("$#{@ticker}", result_type: "recent").take(1).collect do |tweet|
      @tweets_from_ticker << tweet.text
    end

    client.search("@#{@name}", result_type: "recent").take(1).collect do |tweet|
      @tweets_from_hashtag_name << tweet.text
    end

    client.search("##{@name}", result_type: "recent").take(1).collect do |tweet|
      @tweets_from_hashtag_name << tweet.text
    end

    @ticker_sentiment = []
    @at_sentiment = []
    @hashtag_sentiment = []

    for t in @tweets_from_ticker
      @ticker_sentiment << Indico.sentiment(t)
    end

    for t in @tweets_from_at_name
      @at_sentiment << Indico.sentiment(t)
    end

    for t in @tweets_from_hashtag_name
      @hashtag_sentiment << Indico.sentiment(t)
    end

    #@ticker, @name
    @ticker_sentiment_score = (@ticker_sentiment.sum.to_f / @tweets_from_ticker.size) * 100
    @at_sentiment_score = (@at_sentiment.sum.to_f / @at_sentiment.size) * 100
    @hashtag_sentiment_score = (@hashtag_sentiment.sum.to_f / @hashtag_sentiment.size) * 100
    #render text: "#{@ticker_sentiment_score} and #{@price}"
  end

  def update
  end

  def destroy

  end

  def search

  end


end
