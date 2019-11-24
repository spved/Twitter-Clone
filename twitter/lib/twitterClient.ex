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
            stweet = readValue(:ets.lookup(tweets, n))
            stweet
           end)
       end))
       IO.inspect subscribedTweets
       subscribedTweets
    end


    def tweet(userName, tweetData, subscribers, users) do
        Twitter.Client.send(userName, tweetData, subscribers, users)
    end

    def reTweet(userName, tweetData, subscribers, users) do
        Twitter.Client.send(userName, tweetData, subscribers, users)
    end
#helper functions

  def validateUser([]) do
    false
  end
  def validateUser(_) do
    true
  end

  def validateUser(userName, users) do
    validateUser(readValue(:ets.lookup(users, userName)))
  end

  def login(userName, password, users) do
    if validateUser(userName, users) do
      list = readValue(:ets.lookup(users, userName))
      userPassword = List.first(list)
      if userPassword == password do
        :ets.insert(users, {userName, List.replace_at(list, 2, "1")})
      end
    end
  end

  def logout(userName, users) do
    if validateUser(userName, users) do
      list = readValue(:ets.lookup(users, userName))
      :ets.insert(users, {userName, List.replace_at(list, 2, "0")})
    end
  end

  def isLogin(userName, users) do
    List.last(readValue(:ets.lookup(users, userName)))
  end

  def receive(userName, tweetUser, tweet, users) do
    if isLogin(userName, users) == "1" do
      IO.inspect [tweetUser,tweet], label: userName
    end
  end

  def send(userName, tweet, subscribers, users) do
    currentList = readValue(:ets.lookup(subscribers, userName))
     #for each subscriber get tweets
    Enum.map(currentList, fn ni ->
       receive(ni, userName, tweet, users)
    end)
  end


end
