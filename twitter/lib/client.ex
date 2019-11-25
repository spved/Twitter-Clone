defmodule Twitter.Client do
  use GenServer
  def handle_cast({:register,username,password,email}, state) do
      #IO.inspect :ets.first(users)
      #IO.inspect :ets.lookup(users, "user5")
      {_,engine} = state
      #:ets.insert_new(users, {username, [password,email,0]})
      Genserver.cast(engine, {:insertUser, self(), username, password, email})
      state = {username, engine}
  end

   def handle_cast({:delete,users,username}, state) do
     {_,engine} = state
     Genserver.cast(engine, {:deleteUser, self()})
     #:ets.delete(:users, username)
     state = {username, engine}
    end

  def handle_call({:querySubscribedTo, userId, subscribers, tweetUserMap, tweets}, _from, state) do
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

    def handle_cast({:tweet,userName, tweetData, subscribers, users, tableSize, tweets, hashTagTweetMap, mentionUserMap}, state) do
        {_,engine} = state
        Genserver.cast(engine, {:send, userName, tweetData, subscribers, users})
        {_,tweetId,_} = Genserver.call(engine,{:addTweet,tweetData})
        #def handle_cast({:send, self(), tweet, subscribers, users}, state) do
        #Twitter.Client.send(userName, tweetData, subscribers, users)
        #def handle_cast({:addTweetsToUser, user, tweetId}, state) do
        Genserver.cast(engine, {:addTweetsToUser, userName, tweetId})
        #tweetId = Twitter.Helper.addTweet(tweetData,tweets,tableSize)
        Twitter.Helper.readTweet(tweets,tweetId, hashTagTweetMap, users, mentionUserMap)
    end

    def handle_cast({:reTweet,userName, tweetData, subscribers, users}, state) do
        {_,engine} = state
        #def handle_cast({:send, userName, tweet, subscribers, users}, state) do
        Genserver.cast(engine,{:send, userName, tweetData, subscribers, users})
        #Twitter.Client.send(userName, tweetData, subscribers, users)
    end
#helper functions


  def handle_call({:queryHashTags, hashTag, hashTagTweetMap, tweets}, _from, state) do
    currentList = Twitter.Helper.readValue(:ets.lookup(hashTagTweetMap, hashTag))
    Enum.map(currentList, fn ni ->
           IO.inspect ni
           tweet = Twitter.Helper.readValue(:ets.lookup(tweets,ni))
           IO.inspect tweet
          end)
  end

  def handle_call({:queryMentions, userId, mentionUserMap, tweets}, _from, state) do
    currentList = Twitter.Helper.readValue(:ets.lookup(mentionUserMap, userId))
    Enum.map(currentList, fn ni ->
           IO.inspect ni
           tweet = Twitter.Helper.readValue(:ets.lookup(tweets,ni))
           IO.inspect tweet
          end)
  end

  def handle_call({:receive, userName, tweetUser, tweet}, _from, state) do
    {_, engine} = state
    if Twitter.Helper.isLogin(userName, engine) == 1 do
      IO.inspect [tweetUser,tweet], label: userName
    end
  end

  def handle_cast({:subscribe,userId1, userId2, subscribedTo, subscribers}, state) do
    {_,engine} = state
    #userId1 is subscribing to userId2
    IO.inspect :ets.lookup(subscribers, userId2)
    user2Subscribers = Twitter.Helper.readValue(:ets.lookup(subscribers, userId2))
    user2Subscribers = user2Subscribers ++ [userId1]
    #def handle_cast({:addSubscriber, user, suser}, state) do
    #:ets.insert(subscribers, {userId2, user2Subscribers})
    Genserver.cast(engine,{:addSubscriber, userId2, user2Subscribers})
    #:ets.update_counter(subscribers, userId2, user2Subscribers )

    user1SubscribedTo = Twitter.Helper.readValue(:ets.lookup(subscribedTo, userId1))
    user1SubscribedTo = user1SubscribedTo ++ [userId2]
    #:ets.insert(subscribedTo, {userId1, user2Subscribers})
    #def handle_cast({:addSubscriberOf, user, suser}, state) do
    Genserver.cast(engine,{:addSubscriberOf, userId1, user2Subscribers})
   #:ets.update_counter(subscribedTo, userId1, user2Subscribers )

  end

  def handle_call({:setUserName, userName}, _from, state) do
    {_, engine} = state
    state = {userName, engine}
    {:reply, userName, state}
  end


  def handle_cast({:setEngine, engine}, state) do
    {userName,_} = state
    state = {userName, engine}
    {:noreply, state}
  end

  def start_node() do
    {:ok, pid} = GenServer.start_link(__MODULE__, :ok, [])
    pid
  end

  def init(:ok) do
  # {hashId, neighborMap} , {hashId, neighborMap}
  {:ok, {0, []}}
  end


end
