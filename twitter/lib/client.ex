defmodule Twitter.Client do
  use GenServer

  def register(client, username,password,email) do
    GenServer.call(client, {:register, username,password,email})
  end

  def handle_call({:register,username,password,email}, _from, state) do
      {_,engine, tweetList} = state
      Twitter.Engine.insertUser(engine, self(), username, password, email)
      state = {username, engine, tweetList}
      {:reply, username, state}
  end

   def handle_cast({:delete,user}, state) do

     {userName,engine, tweetList} = state
     GenServer.cast(engine, {:deleteUser, userName})
     #:ets.delete(:users, username)
     tweetList = GenServer.call(engine,{:getTweetsOfUser, userName})
    Enum.each(tweetList, fn(tweet) ->
      GenServer.cast(engine, {:deleteTweet, tweet})
    end)
     state = {userName, engine, tweetList}
    #Process.exit(self(), :normal)
     {:noreply, state}
    end

  def handle_call({:querySubscribedTo}, _from, state) do
  {userName,engine, _} = state
   currentList = GenServer.call(engine,{:getSubscribers, userName})
    #for each subscriber get tweets
    subscribedTweets = List.flatten(Enum.map(currentList, fn ni ->
          tweetList = GenServer.call(engine,{:getTweetsOfUser, ni})

           #get tweets for each tweet id
           stweets = Enum.map(tweetList, fn n ->
           stweet = GenServer.call(engine, {:getTweet, n})
            stweet
          end)
       end))
       #IO.inspect subscribedTweets
       subscribedTweets
       {:reply, subscribedTweets, state}
    end

    def handle_cast({:tweet, tweetData}, state) do
        {userName,engine, _} = state
        GenServer.cast(engine, {:send, userName, tweetData})
       tweetId = GenServer.call(engine,{:addTweet,tweetData})
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


  def handle_call({:queryHashTags, hashTag}, _from, state) do
    {userName,engine, _} = state
     currentList = GenServer.call(engine,{:getHashTagTweets, hashTag})
  #  currentList = Twitter.Helper.readValue(:ets.lookup(hashTagTweetMap, hashTag))
      htweets = List.flatten(Enum.map(currentList, fn ni ->
           tweet = GenServer.call(engine,{:getTweet, ni})
           tweet
         end))
      {:reply, htweets, state}
  end

  def handle_call({:queryMentions}, _from, state) do
  {userName,engine, _} = state
  currentList = GenServer.call(engine,{:getMentionedTweets, userName})
   # currentList = Twitter.Helper.readValue(:ets.lookup(mentionUserMap, userId))
    mtweets = List.flatten(Enum.map(currentList, fn ni ->
           tweet = GenServer.call(engine,{:getTweet, ni})
           #tweet = Twitter.Helper.readValue(:ets.lookup(tweets,ni))
           tweet
         end))
    {:reply, mtweets, state}
  end

  def handle_cast({:receive, userName, tweetUser, tweet}, state) do
    {user, engine, tweets} = state
    tweets = if Twitter.Helper.isLogin(userName, engine) == 1 do
      IO.inspect [tweetUser,tweet], label: userName
      tweets
    else
        tweets++tweet
    end
    state = {user, engine, tweets}
    {:noreply, state}
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
    GenServer.cast(engine,{:addSubscriberOf, userId2, userId1})
    #GenServer.cast({:addSubscriberOf, user, suser}, state) do
   #:ets.update_counter(subscribedTo, userId1, user2Subscribers )
   {:noreply, state}
  end

  def handle_call({:loginUser, passwd}, _from, state) do
    {user, engine, tweets} = state
    loggedIn = GenServer.call(engine, {:login, user, passwd})
    rtweets = if loggedIn do
      state = {user, engine, []}
      tweets
    else
      []
    end
    {:reply, rtweets, state}
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
