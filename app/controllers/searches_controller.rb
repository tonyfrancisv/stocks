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
    ticker = params[:q]
    stocks = StockQuote::Stock.quote(ticker)
    name = stocks.name
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

    @tweets = []

    client.search("$#{ticker}", result_type: "recent").take(20).collect do |tweet|
      @tweets << tweet.text
    end

    @ticker_sentiment = []

    for t in @tweets
      @ticker_sentiment << Indico.sentiment(t)
    end


    render text: "#{ticker} #{name} #{@ticker_sentiment}"
  end

  def update
  end

  def destroy

  end

  def search

  end


end
