defmodule Twitter.Engine do
  use GenServer

  #all set functions are cast and all get funtions are call

  def handle_cast({:send, userName, tweet}, state) do
    {users,_,subscribers,_,_,_,_,_} = state
    # {_,_,subscribers,_,_,_,_,_} = state
    currentList = Twitter.Helper.readValue(:ets.lookup(subscribers, userName))
    #currentList = GenServer.call(self(),{:getSubscribers, userName})
     #for each subscriber get tweets
    Enum.map(currentList, fn ni ->
      pid = List.first(Twitter.Helper.readValue(:ets.lookup(users, userName)))
      GenServer.cast(pid, {:receive, ni, userName, tweet})
    end)
    {:noreply, state}
  end

  #login/logout
  
  def handle_call({:login,userName, password}, _from, state) do
    {users,_,_,_,_,_,_,_} = state
    if Twitter.Helper.validateUser(userName, users) do
      list = Twitter.Helper.readValue(:ets.lookup(users, userName))
      userPassword = List.first(list)
      if userPassword == password do
        :ets.insert(users, {userName, List.replace_at(list, 2, 1)})
      end
    end
    {:reply, :ok, state}
  end

  def handle_call({:logout, userName}, _from, state) do
    {users,_,_,_,_,_,_,_} = state
    if Twitter.Helper.validateUser(userName, users) do
      list = Twitter.Helper.readValue(:ets.lookup(users, userName))
      :ets.insert(users, {userName, List.replace_at(list, 2, 0)})
    end
    {:reply,:ok, state}
  end

  #users table get, set, unset

  def insertUser(engine, pid, user, passwd, email) do
   GenServer.call(engine, {:insertUser, pid, user, passwd, email})
  end

  def handle_call({:insertUser, pid, user, passwd, email}, _from, state) do
    {users,_,_,_,_,_,_,_} = state
    IO.inspect :ets.lookup(users, "user3")
    :ets.insert_new(users, {user, [pid, passwd,email,0]})
    {:reply, :ok, state}
  end

  def deleteUser(engine, pid) do
   GenServer.cast(engine, {:deleteUser, pid})
  end

  def deleteUser(engine, pid) do
   GenServer.cast(engine, {:deleteUser, pid})
  end

  def handle_cast({:deleteUser, user}, state) do
    {users,_,_,_,_,_,_,_} = state
    :ets.delete(:users, user)
    {:noreply, state}
  end

  def handle_call({:getUser, userName}, _from, state) do
    {users,_,_,_,_,_,_,_} = state
      list = Twitter.Helper.readValue(:ets.lookup(users, userName))
    {:reply,list, state}
  end

  #insert and get tweet
  def handle_call({:getTweet, tweetId}, _from, state) do
    {_,tweets,_,_,_,_,_,_} = state
    tweet = :ets.lookup(tweets, tweetId)
    IO.inspect tweet, label: "tweet added"
    {:reply, tweet, state}
  end

  def handle_call({:addTweet, tweet}, _from, state) do
    {_,tweets,_,_,_,_,_,tableSize} = state
    id = :ets.update_counter(tableSize, "tweets", {2,1})
    IO.inspect id, label: "id"
    IO.inspect tweet, label: "tweet"

    :ets.insert_new(tweets, {id, tweet})

    IO.inspect :ets.lookup(tweets, id)

    {:reply, id, state}
  end

  #subscribers table insert_new, insert, get
  def handle_call({:getSubscribers, user}, _from, state) do
    {_,_,subscribers,_,_,_,_,_} = state
    list = Twitter.Helper.readValue(:ets.lookup(subscribers, user))
    {:reply, list, state}
  end

  def handle_cast({:addSubscriber, user, suser}, state) do
    {_,_,subscribers,_,_,_,_,_} = state
    list = Twitter.Helper.readValue(:ets.lookup(subscribers, user))
    if list == [] do
      :ets.insert_new(subscribers, {user, [suser]})
    else
      :ets.insert(subscribers, {user, list++[suser]})
    end
    {:noreply, state}
  end

  #subscribedTo table insert_new, insert, get
  def handle_call({:getSubscribersOf, user}, _from, state) do
    IO.inspect user, label: "user"
    {_,_,_,subscribedTo,_,_,_,_} = state
    list = Twitter.Helper.readValue(:ets.lookup(subscribedTo, user))
    IO.inspect list
    #Enum.each list, fn l -> 
     # IO.inspect l
    #end
    {:reply, list, state}
  end

  def handle_cast({:addSubscriberOf, user, suser}, state) do
    {_,_,_,subscribedTo,_,_,_,_} = state
    list = Twitter.Helper.readValue(:ets.lookup(subscribedTo, user))
    if list == [] do
      :ets.insert_new(subscribedTo, {user, [suser]})
    else
      :ets.insert(subscribedTo, {user, list++[suser]})
    end
    {:noreply, state}
  end

  #tweetUserMap table insert_new, insert, get
  def handle_call({:getTweetsOfUser, user}, _from, state) do
    {_,_,_,_,tweetUserMap,_,_,_} = state
    list = Twitter.Helper.readValue(:ets.lookup(tweetUserMap, user))
    {:reply, list, state}
  end

  def handle_cast({:addTweetsToUser, user, tweetId}, state) do
    {_,_,_,_,tweetUserMap,_,_,_} = state
    list = Twitter.Helper.readValue(:ets.lookup(tweetUserMap, user))
    if list == [] do
      :ets.insert_new(tweetUserMap, {user, [tweetId]})
    else
      :ets.insert(tweetUserMap, {user, list++[tweetId]})
    end
    {:noreply, state}
  end

  #mentionUserMap table insert_new, insert, get
  def handle_call({:getMentionedTweets, user}, _from, state) do
    {_,_,_,_,_,mentionUserMap,_,_} = state
    list = Twitter.Helper.readValue(:ets.lookup(mentionUserMap, user))
    {:reply, list, state}
  end

  def handle_cast({:addMentionedTweet, user, tweetId}, state) do
    {_,_,_,_,_,mentionUserMap,_,_} = state
    list = Twitter.Helper.readValue(:ets.lookup(mentionUserMap, user))
    if list == [] do
      :ets.insert_new(mentionUserMap, {user, [tweetId]})
    else
      :ets.insert(mentionUserMap, {user, list++[tweetId]})
    end
    {:noreply, state}
  end

  #hashTagTweetMap table insert_new, insert, get
  def handle_call({:getHashTagTweets, hashTag}, _from, state) do
    {_,_,_,_,_,_,hashTagTweetMap,_} = state
    list = Twitter.Helper.readValue(:ets.lookup(hashTagTweetMap, hashTag))
    {:reply, list, state}
  end

  def handle_cast({:addHashTagTweet, hashTag, tweetId}, state) do
    #{_,_,_,_,_,_,hashTagTweetMap,_} = state
    list = Twitter.Helper.readValue(:ets.lookup(:hashTagTweetMap, hashTag))
    if list == [] do
      :ets.insert_new(:hashTagTweetMap, {hashTag, [tweetId]})
    else
      :ets.insert(:hashTagTweetMap, {hashTag, list++[tweetId]})
    end
    {:noreply, state}
  end

  def handle_call({:print}, _from, state) do
    {users, tweets, subscribers, subscribedTo, tweetUserMap, mentionUserMap, hashTagTweetMap, tableSize} = state

    IO.inspect users, label: "users"
    IO.inspect tweets, label: "tweets"
    IO.inspect subscribers, label: "subscribers"
    IO.inspect subscribedTo, label: "subscribedTo"
    IO.inspect tweetUserMap, label: "tweetUserMap"
    IO.inspect mentionUserMap, label: "mentionUserMap"
    IO.inspect hashTagTweetMap, label: "hashTagTweetMap"
    {:reply, :ok, state}
  end

  def handle_call({:initDB}, _from, state) do
    users = :ets.new(:users, [:named_table,:public])
    tweets = :ets.new(:tweets, [:named_table,:public])
    subscribers = :ets.new(:subscribers, [:named_table,:public])
    subscribedTo = :ets.new(:subscribedTo, [:named_table,:public])
    tweetUserMap = :ets.new(:tweetUserMap, [:named_table,:public])
    mentionUserMap = :ets.new(:mentionUserMap, [:named_table,:public])
    tableSize = :ets.new(:tableSize, [:named_table,:public])
    hashTagTweetMap = "x"

    :ets.insert_new(tableSize, {"tweets", 0})

    state = {users, tweets, subscribers, subscribedTo, tweetUserMap, mentionUserMap, hashTagTweetMap, tableSize}
    {:reply, :ok, state}
  end

   #Functions for testing simulator

   def handle_cast({:getUserTable, userName}, state) do
    {users,_,_,_,_,_,_,_} = state
    #IO.inspect pid
    IO.inspect :ets.lookup(:users, userName), label: "userDetails"
    {:noreply, state}
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
