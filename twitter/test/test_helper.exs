defmodule Twitter.Test.Helper do
  #create engine
  def createEngineAndClient do
    engine = Twitter.Engine.start_node()
    #GenServer.call(engine, {:initDB})
    clients =  Enum.map(1..5, fn _ ->
          pid = Twitter.Client.start_node()
          GenServer.cast(pid, {:setEngine, engine})
          pid
        end)
        #IO.inspect clients
    {engine, clients}
  end

  def createTestCase1(engine, clients) do

    addUsers(engine, clients)


  end

  def addUsers(_, clients) do
    passwd = "passwd"
    email = "user@abc.com"
    Enum.each(0..4, fn count ->
      pid = Enum.at(clients,count)
      Twitter.Client.register(pid, to_string(count), passwd, email)
    end)
    IO.inspect :ets.lookup(:users, "1")
    addTweets()
    addSubscribers()
    addSubscribersOf()
    addUserTweetMap()
    addMentionUserMap()
    addHashTagTweetMap()

  end

  def addTweets() do
    id = :ets.update_counter(:tableSize, "tweets", {2,1})
    :ets.insert_new(:tweets, {id, "tweet 1 #tweet1 @1 @2"})
    id = :ets.update_counter(:tableSize, "tweets", {2,1})
    :ets.insert_new(:tweets, {id, "tweet 2 #tweet2 @2 @3"})
    id = :ets.update_counter(:tableSize, "tweets", {2,1})
    :ets.insert_new(:tweets, {id, "tweet 3 #tweet3 #tweet2 @3 @2 @2"})
  end

  def addSubscribers() do
    :ets.insert_new(:subscribers, {"1", ["2", "3", "4"]})
    :ets.insert_new(:subscribers, {"2", ["0", "3", "4"]})
    :ets.insert_new(:subscribers, {"3", ["0"]})
    :ets.insert_new(:subscribers, {"4", ["2", "1", "0"]})
    #IO.inspect :ets.lookup(:subscribers, "1")
  end

  def addSubscribersOf() do
    :ets.insert_new(:subscribedTo, {"0", ["2", "3", "4"]})
    :ets.insert_new(:subscribedTo, {"1", ["4"]})
    :ets.insert_new(:subscribedTo, {"2", ["1","4"]})
    :ets.insert_new(:subscribedTo, {"3", ["1", "2"]})
    :ets.insert_new(:subscribedTo, {"4", ["2", "1"]})
    #IO.inspect :ets.lookup(:subscribedTo, "1")
  end

  def addUserTweetMap() do
    :ets.insert_new(:tweetUserMap, {"1", [1,2]})
    :ets.insert_new(:tweetUserMap, {"2", [2,3]})
    :ets.insert_new(:tweetUserMap, {"3", [1,3]})
    :ets.insert_new(:tweetUserMap, {"4", [3]})
    #IO.inspect :ets.lookup(:tweetUserMap, "1")
  end

  def addMentionUserMap() do
    :ets.insert_new(:mentionUserMap, {"1", [1]})
    :ets.insert_new(:mentionUserMap, {"2", [2,3,1]})
    :ets.insert_new(:mentionUserMap, {"3", [2,3]})
    #IO.inspect :ets.lookup(:mentionUserMap, "1")

  end

  def addHashTagTweetMap() do
    :ets.insert_new(:hashTagTweetMap, {"tweet1", [1]})
    :ets.insert_new(:hashTagTweetMap, {"tweet2", [2,3]})
    :ets.insert_new(:hashTagTweetMap, {"tweet3", [3]})
    #IO.inspect :ets.lookup(:hashTagTweetMap, "tweet1")

  end

end
ExUnit.start()
