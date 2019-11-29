defmodule Twitter.Simulator do


  def simulate(numUsers, numTweets, clients, engine) do

  

  simulation = :ets.new(:simulation, [:named_table,:public])
  :ets.insert_new(simulation, {"tweetCount", 0})



  #Register all the users
  #IO.inspect "Registering users"
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
  #IO.inspect "Deletion"
  #IO.inspect length(clients)

deletedUsers = Enum.map((1..round(length(clients)*0.1)), fn(x) ->
          deleteUser = Enum.random(clients)
   #       IO.inspect deleteUser, label: "deleteUser"
          #IO.inspect "Before deletion"
          #deleteUser(engine, pid)
          GenServer.cast(deleteUser, {:getUserTable, deleteUser})
          GenServer.cast(deleteUser, {:delete, deleteUser})
           #IO.inspect "After deletion"
          GenServer.cast(deleteUser, {:getUserTable, deleteUser})
          deleteUser
     end)

#IO.inspect deletedUsers, label: "deletedUsers"

#IO.inspect clients, label: "clientsBefore"
 clients = clients -- deletedUsers
#IO.inspect clients, label: "clientsAfter"


 #IO.inspect "Subscribe"

  Enum.map((1..round(length(clients)*0.9)), fn(x) ->
     userSubscribing = Enum.random(clients)
     userSubscribingTo = Enum.random(clients)
     #IO.inspect userSubscribing, label: "userSubscribing"
     #IO.inspect userSubscribingTo, label: "userSubscribingTo"
     userName = GenServer.call(userSubscribingTo,{:getUserName})
     #IO.inspect userName, label: "userName"
     GenServer.cast(userSubscribing,{:subscribe,userSubscribing, userName})
     #IO.inspect "checking subscription"
     GenServer.call(userSubscribingTo,{:getSubscribersOf, userName})
 end)


 #IO.inspect "query subscribed to"

 queryUser = Enum.random(clients)
 #IO.inspect queryUser, label: "queryUser"
 GenServer.call(queryUser,{:querySubscribedTo})


 tweetList=[]
 tweetList = tweetList ++ ["Tweet1","Tweet2","Tweet3","Tweet4","Tweet5","Tweet6","Tweet7","Tweet8","Tweet9","Tweet10"]

#IO.inspect "tweet"

 startTime = System.system_time(:millisecond)

 Enum.each(clients, fn(user) ->
 Enum.map((1..numTweets), fn(x) ->
    tweetData = Enum.random(tweetList)
  #  user = Enum.random(clients)
 #IO.inspect user, label: "user to tweet"
  #IO.inspect "subscribers pf chosen user"
  userName = GenServer.call(user,{:getUserName})
  #IO.inspect userName, label: "userName"
 GenServer.call(user,{:getSubscribersOf, userName})
 [{_, num_tweets}] = :ets.lookup(:simulation, "tweetCount")
 :ets.insert(simulation, {"tweetCount", num_tweets+1})
 #IO.inspect num_tweets+1, label: "num_tweets+1"
 GenServer.cast(user,{:tweet, tweetData})
 #IO.inspect "getTweet"
#GenServer.call(engine,{:getTweet, 1})
end)
 end)


 
 Enum.map((1..round(length(clients)*0.2)), fn(x) ->
  userToRetweet = Enum.random(clients)
  #IO.inspect userToRetweet, label: "userToRetweet"
  userName = GenServer.call(userToRetweet,{:getUserName})
  #IO.inspect userName, label: "userName"
  list = GenServer.call(engine,{:getSubscribersOf, userName})
  #IO.inspect list, label: "list"
  choosenUser = Enum.at(list, 0)
  #IO.inspect choosenUser, label: "choosenUser"
  tweetsOfUser = GenServer.call(engine,{:getTweetsOfUser, choosenUser})
  #IO.inspect tweetsOfUser, label: "tweetsOfUser"
  tweetId = Enum.at(tweetsOfUser, 0)
  #IO.inspect tweetId, label: "tweetId"
  tweet = GenServer.call(engine,{:getTweet, tweetId})
  #IO.inspect tweet, label: "tweet"
  GenServer.cast(userToRetweet,{:reTweet, tweetId, tweet})
  #GenServer.cast({:reTweet,userName, tweetData, subscribers, users}, state) do

  #if(tweetToBeReTweeted != nil) do
  #GenServer.cast({:reTweet,userName, tweetData, subscribers, users})
    #IO.inspect "not nil"
  #else
    #IO.inspect "nil"
  #end
 end)




 deleteUser = Enum.random(clients)
#IO.inspect deleteUser, label: "deleteUser to delete tweets"
 userName = GenServer.call(deleteUser,{:getUserName})
 GenServer.cast(deleteUser, {:delete, deleteUser})
    infinite(numUsers*numTweets*0.8, startTime)
   end

   def infinite(total_tweets, startTime) do
   [{_, num_tweets}] = :ets.lookup(:simulation, "tweetCount")
   #[{_, tr}] = :ets.lookup(:table, "tr")
   # IO.inspect {tr, count}
    if num_tweets >= total_tweets do
      #simulation = :ets.new(:simulation, [:named_table,:public])
      #:ets.insert_new(simulation, {"tweetCount", 0})

      currentTime = System.system_time(:millisecond)
      endTime = currentTime - startTime
      IO.puts "Convergence Achieved in = "<> Integer.to_string(endTime)<> "ms"
      #IO.puts("Converged")

      #IO.puts(maxHops)
    else
    #IO.inspect num_tweets, label: "num_tweets"
    infinite(total_tweets, startTime)
   end
   end
end
