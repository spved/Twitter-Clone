defmodule Twitter.Client do


  def readValue([]) do
    []
  end

  def readValue(data) do
    [{ _ , list}] = data
    list
  end

  def querySubscribedTo(userId, subscribers, tweetUserMap, tweets) do
   currentList = readValue(:ets.lookup(subscribers, userId))
    #for each subscriber get tweets
    subscribedTweets = List.flatten(Enum.map(currentList, fn ni ->
         #IO.inspect ni
          tweetList = readValue(:ets.lookup(tweetUserMap, ni))
           #get tweets for each tweet id
           stweets = Enum.map(tweetList, fn n ->
            [{_, stweet}] = :ets.lookup(tweets, n)
            stweet
           end)
       end))
       IO.inspect subscribedTweets
       subscribedTweets
    end



  def login(userId, password, users) do
  end

  def logout(userId, users) do
  end

  def isLogin(userId, users) do
    List.last(readValue(:ets.lookup(users, userId)))
  end

end
