defmodule Twitter.Simulator do


  def simulate(numUsers, numTweets, clients, engine) do

  users = :ets.new(:users, [:named_table,:public])


  :ets.insert_new(users, {"user1", ["pwd_user1","user1@mail.com","1"]})
  :ets.insert_new(users, {"user2", ["pwd_user2","user2@mail.com","0"]})
  :ets.insert_new(users, {"user3", ["pwd_user3","user3@mail.com","0"]})
  :ets.insert_new(users, {"user4", ["pwd_user4","user4@mail.com","0"]})
  :ets.insert_new(users, {"user5", ["pwd_user5","user5@mail.com","0"]})

  tweets = :ets.new(:tweets, [:named_table,:public])

  :ets.insert_new(tweets, {"T1", "#DOS project uses #GenServer for doing cast @user3"})
  :ets.insert_new(tweets, {"T2", "#Elixir vs #Scala"})
  :ets.insert_new(tweets, {"T3", "#Concurrency @user2 is main concept of #DOS"})
  :ets.insert_new(tweets, {"T4", "@user2 department"})
  :ets.insert_new(tweets, {"T5", "Project is due on @user1"})

  #subscribers = bag.new()
  #Bag.add_new!(subscribers, {})

  subscribers = :ets.new(:subscribers, [:named_table,:public])

  :ets.insert_new(subscribers, {"user1", ["user3","user2","user6"]})
  :ets.insert_new(subscribers, {"user2", ["user6"]})
  :ets.insert_new(subscribers, {"user3", ["user1","user5","user4"]})
  :ets.insert_new(subscribers, {"user4", ["user5"]})
  :ets.insert_new(subscribers, {"user5", ["user3","user2"]})

  subscribedTo = :ets.new(:subscribedTo, [:named_table,:public])

  :ets.insert_new(subscribedTo, {"user1", ["user5","user6"]})
  :ets.insert_new(subscribedTo, {"user2", ["user1","user3"]})
  :ets.insert_new(subscribedTo, {"user3", ["user1","user6"]})
  :ets.insert_new(subscribedTo, {"user4", ["user2","user3"]})
  :ets.insert_new(subscribedTo, {"user5", []})

  tweetUserMap = :ets.new(:tweetUserMap, [:named_table,:public])

  :ets.insert_new(tweetUserMap, {"user1", ["T1","T5"]})
  :ets.insert_new(tweetUserMap, {"user2", ["T2","T6"]})
  :ets.insert_new(tweetUserMap, {"user3", ["T8"]})
  :ets.insert_new(tweetUserMap, {"user4", ["T4","T9"]})
  :ets.insert_new(tweetUserMap, {"user5", ["T3"]})

  mentionUserMap = :ets.new(:mentionUserMap, [:named_table,:public])

  :ets.insert_new(mentionUserMap, {"user1", ["T5"]})
  :ets.insert_new(mentionUserMap, {"user2", ["T3","T4"]})
  :ets.insert_new(mentionUserMap, {"user3", ["T1"]})
  :ets.insert_new(mentionUserMap, {"user4", []})
  :ets.insert_new(mentionUserMap, {"user5", []})


  hashTagTweetMap = :ets.new(:hashTagTweetMap, [:named_table,:public])

  :ets.insert_new(hashTagTweetMap, {"#DOS", ["T1","T3"]})
  :ets.insert_new(hashTagTweetMap, {"#GenServer", ["T1"]})
  :ets.insert_new(hashTagTweetMap, {"#Concurrency", ["T3"]})
  :ets.insert_new(hashTagTweetMap, {"#Elixir", ["T2"]})
  :ets.insert_new(hashTagTweetMap, {"#Scala", ["T2"]})

  tableSize = :ets.new(:tableSize, [:named_table,:public])

  :ets.insert_new(tableSize, {"users", 5})
  :ets.insert_new(tableSize, {"tweets", 5})

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

   end
end
