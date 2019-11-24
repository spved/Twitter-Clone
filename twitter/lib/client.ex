defmodule Twitter.Client do
  use GenServer



  def querySubscribedTo(userId, subscribers, tweetUserMap, tweets) do
   currentList = Twitter.Helper.readValue(:ets.lookup(subscribers, userId))
    #for each subscriber get tweets
    subscribedTweets = List.flatten(Enum.map(currentList, fn ni ->
         #IO.inspect ni
          tweetList = Twitter.Helper.readValue(:ets.lookup(tweetUserMap, ni))
           #get tweets for each tweet id
           stweets = Enum.map(tweetList, fn n ->
            stweet = Twitter.Helper.readValue(:ets.lookup(tweets, n))
            stweet
           end)
       end))
       IO.inspect subscribedTweets
       subscribedTweets
    end


    def tweet(userName, tweetData, subscribers, users, tableSize, tweets, hashTagTweetMap, mentionUserMap) do
        Twitter.Client.send(userName, tweetData, subscribers, users)
        tweetId = Twitter.Helper.addTweet(tweetData,tweets,tableSize)
        Twitter.Helper.readTweet(tweets,tweetId, hashTagTweetMap, users, mentionUserMap)
    end

    def reTweet(userName, tweetData, subscribers, users) do
        Twitter.Client.send(userName, tweetData, subscribers, users)
    end
#helper functions



  def register(username,password,email,users) do
    #IO.inspect :ets.first(users)
    #IO.inspect :ets.lookup(users, "user5")
    :ets.insert_new(users, {username, [username,password,email]})
  end

  def delete(users,username) do
   :ets.delete(:users, username)
  end

  def queryHashTags(hashTag, hashTagTweetMap, tweets) do
    currentList = Twitter.Helper.readValue(:ets.lookup(hashTagTweetMap, hashTag))
    Enum.map(currentList, fn ni ->
           IO.inspect ni
           tweet = Twitter.Helper.readValue(:ets.lookup(tweets,ni))
           IO.inspect tweet
          end)
  end

  def queryMentions(userId, mentionUserMap, tweets) do
    currentList = Twitter.Helper.readValue(:ets.lookup(mentionUserMap, userId))
    Enum.map(currentList, fn ni ->
           IO.inspect ni
           tweet = Twitter.Helper.readValue(:ets.lookup(tweets,ni))
           IO.inspect tweet
          end)
  end


  def receive(userName, tweetUser, tweet, users) do
    if Twitter.Helper.isLogin(userName, users) == "1" do
      IO.inspect [tweetUser,tweet], label: userName
    end
  end

  def subscribe(userId1, userId2, subscribedTo, subscribers) do
    #userId1 is subscribing to userId2
    IO.inspect :ets.lookup(subscribers, userId2)
    user2Subscribers = Twitter.Helper.readValue(:ets.lookup(subscribers, userId2))
    user2Subscribers = user2Subscribers ++ [userId1]
    :ets.insert(subscribers, {userId2, user2Subscribers})
    #:ets.update_counter(subscribers, userId2, user2Subscribers )

    user1SubscribedTo = Twitter.Helper.readValue(:ets.lookup(subscribedTo, userId1))
    user1SubscribedTo = user1SubscribedTo ++ [userId2]
    :ets.insert(subscribedTo, {userId1, user2Subscribers})
   #:ets.update_counter(subscribedTo, userId1, user2Subscribers )

  end

  def start_node() do
    {:ok, pid} = GenServer.start_link(__MODULE__, :ok, [])
    pid
  end

  def init(:ok) do
  # {hashId, neighborMap} , {hashId, neighborMap}
  {:ok, 0}
  end


end
