defmodule Twitter.Simulator do


  def simulate(numUsers, numTweets, clients, engine) do

  users_table = :ets.new(:users_table, [:named_table,:public])
  #users = :ets.new(:users, [:named_table,:public])


  :ets.insert_new(users_table, {"user1", ["pwd_user1","user1@mail.com",1]})
  :ets.insert_new(users_table, {"user2", ["pwd_user2","user2@mail.com",0]})
  :ets.insert_new(users_table, {"user3", ["pwd_user3","user3@mail.com",0]})
  :ets.insert_new(users_table, {"user4", ["pwd_user4","user4@mail.com",0]})
  :ets.insert_new(users_table, {"user5", ["pwd_user5","user5@mail.com",0]})

  tweets_table = :ets.new(:tweets_table, [:named_table,:public])

  :ets.insert_new(tweets_table, {"T1", "#DOS project uses #GenServer for doing cast @user3"})
  :ets.insert_new(tweets_table, {"T2", "#Elixir vs #Scala"})
  :ets.insert_new(tweets_table, {"T3", "#Concurrency @user2 is main concept of #DOS"})
  :ets.insert_new(tweets_table, {"T4", "@user2 department"})
  :ets.insert_new(tweets_table, {"T5", "Project is due on @user1"})

  #subscribers = bag.new()
  #Bag.add_new!(subscribers, {})

  subscribers_table = :ets.new(:subscribers_table, [:named_table,:public])

  :ets.insert_new(subscribers_table, {"user1", ["user3","user2","user6"]})
  :ets.insert_new(subscribers_table, {"user2", ["user6"]})
  :ets.insert_new(subscribers_table, {"user3", ["user1","user5","user4"]})
  :ets.insert_new(subscribers_table, {"user4", ["user5"]})
  :ets.insert_new(subscribers_table, {"user5", ["user3","user2"]})

  subscribedTo_table = :ets.new(:subscribedTo_table, [:named_table,:public])

  :ets.insert_new(subscribedTo_table, {"user1", ["user5","user6"]})
  :ets.insert_new(subscribedTo_table, {"user2", ["user1","user3"]})
  :ets.insert_new(subscribedTo_table, {"user3", ["user1","user6"]})
  :ets.insert_new(subscribedTo_table, {"user4", ["user2","user3"]})
  :ets.insert_new(subscribedTo_table, {"user5", []})

  tweetUserMap_table = :ets.new(:tweetUserMap_table, [:named_table,:public])

  :ets.insert_new(tweetUserMap_table, {"user1", ["T1","T5"]})
  :ets.insert_new(tweetUserMap_table, {"user2", ["T2","T6"]})
  :ets.insert_new(tweetUserMap_table, {"user3", ["T8"]})
  :ets.insert_new(tweetUserMap_table, {"user4", ["T4","T9"]})
  :ets.insert_new(tweetUserMap_table, {"user5", ["T3"]})

  mentionUserMap_table = :ets.new(:mentionUserMap_table, [:named_table,:public])

  :ets.insert_new(mentionUserMap_table, {"user1", ["T5"]})
  :ets.insert_new(mentionUserMap_table, {"user2", ["T3","T4"]})
  :ets.insert_new(mentionUserMap_table, {"user3", ["T1"]})
  :ets.insert_new(mentionUserMap_table, {"user4", []})
  :ets.insert_new(mentionUserMap_table, {"user5", []})


  hashTagTweetMap_table = :ets.new(:hashTagTweetMap_table, [:named_table,:public])

  :ets.insert_new(hashTagTweetMap_table, {"#DOS", ["T1","T3"]})
  :ets.insert_new(hashTagTweetMap_table, {"#GenServer", ["T1"]})
  :ets.insert_new(hashTagTweetMap_table, {"#Concurrency", ["T3"]})
  :ets.insert_new(hashTagTweetMap_table, {"#Elixir", ["T2"]})
  :ets.insert_new(hashTagTweetMap_table, {"#Scala", ["T2"]})

  tableSize_table = :ets.new(:tableSize_table, [:named_table,:public])

  :ets.insert_new(tableSize_table, {"users", 5})
  :ets.insert_new(tableSize_table, {"tweets", 5})

  simulation = :ets.new(:simulation, [:named_table,:public])
  :ets.insert_new(simulation, {"tweetCount", 0})



  #Register all the users
  IO.inspect "Registering users"
          Enum.each(Enum.with_index(clients), fn({x, i}) ->
            user = Twitter.Simulator.Helper.generateUserId(i)
            pwd = Twitter.Simulator.Helper.generatePassword(i)
            mail = Twitter.Simulator.Helper.generateMail(i)
            GenServer.call(x, {:register, user, pwd, mail})
            GenServer.call(engine, {:login, user, pwd})
          end)

# {_,_,users} =
# GenServer.call(engine,{:getUserTable})

  #Deleting users randomly
  IO.inspect "Deletion"
  IO.inspect length(clients)

deletedUsers = Enum.map((1..round(length(clients)*0.1)), fn(x) ->
          deleteUser = Enum.random(clients)
          IO.inspect deleteUser, label: "deleteUser"
          #IO.inspect "Before deletion"
          #deleteUser(engine, pid)
          GenServer.cast(deleteUser, {:getUserTable, deleteUser})
          GenServer.cast(deleteUser, {:delete, deleteUser})
           #IO.inspect "After deletion"
          GenServer.cast(deleteUser, {:getUserTable, deleteUser})
          deleteUser
     end)

IO.inspect deletedUsers, label: "deletedUsers"

IO.inspect clients, label: "clientsBefore"
 clients = clients -- deletedUsers
IO.inspect clients, label: "clientsAfter"


 IO.inspect "Subscribe"

  Enum.map((1..round(length(clients)*0.9)), fn(x) ->
     userSubscribing = Enum.random(clients)
     userSubscribingTo = Enum.random(clients)
     IO.inspect userSubscribing, label: "userSubscribing"
     IO.inspect userSubscribingTo, label: "userSubscribingTo"
     userName = GenServer.call(userSubscribingTo,{:getUserName})
     IO.inspect userName, label: "userName"
     GenServer.cast(userSubscribing,{:subscribe,userSubscribing, userName})
     IO.inspect "checking subscription"
     GenServer.call(userSubscribingTo,{:getSubscribersOf, userName})
 end)

 IO.inspect "query subscribed to"

 queryUser = Enum.random(clients)
 IO.inspect queryUser, label: "queryUser"
 GenServer.call(queryUser,{:querySubscribedTo})

 tweetList=[]
 tweetList = tweetList ++ ["Tweet1","Tweet2","Tweet3","Tweet4","Tweet5","Tweet6","Tweet7","Tweet8","Tweet9","Tweet10"]

 IO.inspect "tweet"

 Enum.each(clients, fn(user) ->
 Enum.map((1..numTweets), fn(x) ->
    tweetData = Enum.random(tweetList)
  #  user = Enum.random(clients)
 IO.inspect user, label: "user to tweet"
  IO.inspect "subscribers pf chosen user"
  userName = GenServer.call(user,{:getUserName})
  IO.inspect userName, label: "userName"
 GenServer.call(user,{:getSubscribersOf, userName})
 [{_, num_tweets}] = :ets.lookup(:simulation, "tweetCount")
 :ets.insert(simulation, {"tweetCount", num_tweets+1})
 #IO.inspect num_tweets+1, label: "num_tweets+1"
 GenServer.cast(user,{:tweet, tweetData})
 #IO.inspect "getTweet"
#GenServer.call(engine,{:getTweet, 1})
end)
 end)


 deleteUser = Enum.random(clients)
 IO.inspect deleteUser, label: "deleteUser to delete tweets"
 userName = GenServer.call(deleteUser,{:getUserName})
 GenServer.cast(deleteUser, {:delete, deleteUser})


   #[{_, currentList}] = :ets.lookup(hashTagTweetMap, "#Concurrency")
  #IO.inspect currentList

    #IO.inspect length(users)
    #IO.inspect :ets.lookup(users, "user2")
   #register("user6","pwd_user6","user6@gmail.com",users)
   #IO.inspect :ets.lookup(users, "user6")

   #Twitter.register("user6","pwd_user6","user6@gmail.com",users)
   #IO.inspect :ets.lookup(users, "user6")

   #Twitter.tweet("user3", "tweet1", subscribers)
   #Twitter.Client.querySubscribedTo("user3",subscribers,tweetUserMap,tweets)
   #Twitter.Client.querySubscribedTo("user6",subscribers,tweetUserMap, tweets)

   #Twitter.Client.isLogin("user3", users)
   #Twitter.Client.isLogin("user7", users)
   #Twitter.Client.login("user4", "pwd_uer4", users)
   #Twitter.Client.login("user4", "pwd_user4", users)
   #Twitter.Client.login("user7", "pwd_uer4", users)

   #Twitter.Client.tweet("user3", "Got the first tweet #hiveFive", subscribers, users)
   #Twitter.Client.reTweet("user5", "Got the first tweet #hiveFive", subscribers, users)

   #Twitter.Client.logout("user4", users)
   #Twitter.Client.tweet("user3", "Got the second tweet #hiveFive", subscribers, users)

   #Twitter.queryMentions("user2", mentionUserMap, tweets)

   #IO.inspect "Before subscribe"
   #IO.inspect :ets.lookup(subscribers, "user2")
   #IO.inspect :ets.lookup(subscribedTo, "user4")

  #Twitter.Helper.subscribe("user4","user2", subscribedTo, subscribers)

   #IO.inspect "After subscribe"

   #IO.inspect :ets.lookup(subscribers, "user2")
   #IO.inspect :ets.lookup(subscribedTo, "user4")

   #IO.inspect :ets.lookup(tweetUserMap, "user3")

  #Twitter.Helper.updateTweetUserMap("user3", "T10", tweetUserMap)

  #IO.inspect :ets.lookup(tweetUserMap, "user3")

  #IO.inspect "size"
  #Twitter.Helper.addTweet("tweets @user3 #UF",tweets, tableSize)

  #IO.inspect :ets.lookup(tweets, "T6")
  #IO.inspect "before"
  #IO.inspect :ets.lookup(mentionUserMap, "user3")

  #Twitter.Helper.readTweet(tweets,"T6",hashTagTweetMap, users, mentionUserMap)

  #IO.inspect "after"
  #IO.inspect :ets.lookup(mentionUserMap, "user3")
  #IO.inspect :ets.lookup(hashTagTweetMap, "#UF")

  #Testing all the main functions

  # Register
  #IO.inspect "Before Register"



  #Twitter.Client.register("user6","user6_pwd","user6@email.com",users, tableSize)

  #IO.inspect "Before Register"

    infinite(numUsers*numTweets*0.8)
   end

   def infinite(total_tweets) do
   [{_, num_tweets}] = :ets.lookup(:simulation, "tweetCount")
   #[{_, tr}] = :ets.lookup(:table, "tr")
   # IO.inspect {tr, count}
    if num_tweets >= total_tweets do
      #simulation = :ets.new(:simulation, [:named_table,:public])
      #:ets.insert_new(simulation, {"tweetCount", 0})

      #IO.puts(maxHops)
    else
    IO.inspect num_tweets, label: "num_tweets"
    infinite(total_tweets)
   end
   end
end
