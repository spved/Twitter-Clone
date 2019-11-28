defmodule Twitter.Client do
  use GenServer

  def handle_cast({:register,username,password,email}, state) do
      IO.inspect username
      #IO.inspect :ets.first(users)
      #IO.inspect :ets.lookup(users, "user5")
      {_,engine, tweetList} = state
      #:ets.insert_new(users, {username, [password,email,0]})
      Twitter.Engine.insertUser(engine, self(), username, password, email)
      #GenServer.cast(engine, {:insertUser, self(), username, password, email})
      state = {username, engine, tweetList}
      {:noreply, state}
  end

   def handle_cast({:delete,user}, state) do

     {userName,engine, tweetList} = state
     GenServer.cast(engine, {:deleteUser, userName})
     #:ets.delete(:users, username)
     state = {userName, engine, tweetList}
     Process.exit(self(), :normal)
     {:noreply, state}
    end

  def handle_call({:querySubscribedTo, userId}, _from, state) do
  {userName,engine, _} = state
   currentList = GenServer.call(engine,{:getSubscribers, userName})

  #currentList = Twitter.Helper.readValue(:ets.lookup(subscribers, userId))
    #for each subscriber get tweets
    subscribedTweets = List.flatten(Enum.map(currentList, fn ni ->
         IO.inspect ni
          tweetList = Twitter.Helper.readValue(GenServer.call(engine,{:getTweetsOfUser, ni}))
       #   tweetList = Twitter.Helper.readValue(:ets.lookup(tweetUserMap, ni))
           #get tweets for each tweet id
           stweets = Enum.map(tweetList, fn n ->
             stweet = GenServer.call({:getTweet, n})
       #     stweet = Twitter.Helper.readValue(:ets.lookup(tweets, n))
            stweet
          end)
       end))
       IO.inspect subscribedTweets
       subscribedTweets
       {:reply, subscribedTweets, state}
    end

    def handle_cast({:tweet,userName, tweetData}, state) do
        {_,engine, _} = state
        GenServer.cast(engine, {:send, userName, tweetData})
       tweetId = GenServer.call(engine,{:addTweet,tweetData})
       #IO.inspect a, label: "a"
       #IO.inspect b, label: "b"
       #IO.inspect c, label: "c"
       #{_,tweetId} = GenServer.call(engine,{:addTweet,tweetData})
       #tweetId = "T2"
        IO.inspect tweetId, label: "tweetId"
        #def handle_cast({:send, self(), tweet, subscribers, users}, state) do
        #Twitter.Client.send(userName, tweetData, subscribers, users)
        #def handle_cast({:addTweetsToUser, user, tweetId}, state) do
        GenServer.cast(engine, {:addTweetsToUser, userName, tweetId})
        #tweetId = Twitter.Helper.addTweet(tweetData,tweets,tableSize)
        Twitter.Helper.readTweet(tweetData,tweetId, engine)
        {:noreply, state}
    end

    def handle_cast({:reTweet,userName, tweetData, subscribers, users}, state) do
        {_,engine, _} = state
        #def handle_cast({:send, userName, tweet, subscribers, users}, state) do
        GenServer.cast(engine,{:send, userName, tweetData, subscribers, users})
        #Twitter.Client.send(userName, tweetData, subscribers, users)
    end
#helper functions


  def handle_call({:queryHashTags, hashTag, hashTagTweetMap, tweets}, _from, state) do
    {userName,engine, _} = state
     currentList = Twitter.Helper.readValue(GenServer.call(engine,{:getHashTagTweets, hashTag}))
  #  currentList = Twitter.Helper.readValue(:ets.lookup(hashTagTweetMap, hashTag))
    Enum.map(currentList, fn ni ->
           IO.inspect ni
          #tweet = Twitter.Helper.readValue(:ets.lookup(tweets,ni))
           tweet = Twitter.Helper.readValue(GenServer.call(engine,{:getTweet, ni}))
           IO.inspect tweet
          end)
  end

  def handle_call({:queryMentions, userId, mentionUserMap, tweets}, _from, state) do
  {userName,engine, _} = state
  currentList = Twitter.Helper.readValue(GenServer.call(engine,{:getMentionedTweets, userName}))
   # currentList = Twitter.Helper.readValue(:ets.lookup(mentionUserMap, userId))
    Enum.map(currentList, fn ni ->
           IO.inspect ni
           tweet = Twitter.Helper.readValue(GenServer.call(engine,{:getTweet, ni}))
           #tweet = Twitter.Helper.readValue(:ets.lookup(tweets,ni))
           IO.inspect tweet
          end)
  end

  def handle_cast({:receive, userName, tweetUser, tweet}, _from, state) do
    {user, engine, tweets} = state
    if Twitter.Helper.isLogin(userName, engine) == 1 do
      IO.inspect [tweetUser,tweet], label: userName 
    else
        tweets = tweets++tweet  
    end
    state = {user, engine, tweets}
  end

  def handle_call({:getUserName}, _from, state) do
    {userName,_, _} = state
    {:reply, userName, state}
  end

  def handle_cast({:subscribe,user1, userId2}, state) do
    {userId1 ,engine, _} = state
    #userId1 is subscribing to userId2
    #IO.inspect :ets.lookup(subscribers, userId2)
    GenServer.cast(engine,{:addSubscriber, userId1, userId2})
    #user2Subscribers = Twitter.Helper.readValue(GenServer.call(engine,{:getSubscribers, userId2})) 
    #user2Subscribers = Twitter.Helper.readValue(:ets.lookup(subscribers, userId2))
    #user2Subscribers = user2Subscribers ++ [userId1]
    #def handle_cast({:addSubscriber, user, suser}, state) do
    #:ets.insert(subscribers, {userId2, user2Subscribers})
    #GenServer.cast(engine,{:addSubscriber, userId2, user2Subscribers})
    #:ets.update_counter(subscribers, userId2, user2Subscribers )

    #user1SubscribedTo = Twitter.Helper.readValue(:ets.lookup(subscribedTo, userId1))
    #user1SubscribedTo = user1SubscribedTo ++ [userId2]
    #:ets.insert(subscribedTo, {userId1, user2Subscribers})
    #def handle_cast({:addSubscriberOf, user, suser}, state) do
    GenServer.cast(engine,{:addSubscriberOf, userId2, userId1})
    #GenServer.cast({:addSubscriberOf, user, suser}, state) do
   #:ets.update_counter(subscribedTo, userId1, user2Subscribers )
   {:noreply, state}
  end

  # testing functions

   def handle_cast({:getUserTable, pid}, state) do
    {userName,engine, _} = state
    #{users,_,_,_,_,_,_,_} = state
    GenServer.cast(engine, {:getUserTable, userName})
    #IO.inspect :ets.lookup(:users, pid)
    {:noreply, state}
  end

  def handle_call({:getSubscribersOf, userName}, _from, state) do
    {_, engine, tweetList} = state
    GenServer.call(engine, {:getSubscribersOf, userName})
    state = {userName, engine, tweetList}
    {:reply, userName, state}
  end


  def handle_call({:setUserName, userName}, _from, state) do
    {_, engine, tweetList} = state
    state = {userName, engine, tweetList}
    {:reply, userName, state}
  end


  def handle_cast({:setEngine, engine}, state) do
    {userName,_, tweetList} = state
    state = {userName, engine, tweetList}
    {:noreply, state}
  end

  def start_node() do
    {:ok, pid} = GenServer.start_link(__MODULE__, :ok, [])
    pid
  end

  def init(:ok) do
  # {hashId, neighborMap} , {hashId, neighborMap}
  {:ok, {0, [],[]}}
  end

end
