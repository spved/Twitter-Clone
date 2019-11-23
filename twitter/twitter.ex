defmodule Twitter do

def register(username,password,email,users) do
  #IO.inspect :ets.first(users)
  #IO.inspect :ets.lookup(users, "5")
  :ets.insert_new(users, {"6", [username,password,email]})
end

def delete(users,username) do
 :ets.delete(:users, username)
end

def tweet(userId, tweetData, subscribers) do
 IO.inspect :ets.lookup(subscribers, userId)
  [{_, currentList}] = :ets.lookup(subscribers, userId)
  Enum.map(currentList, fn ni ->
         IO.inspect ni
         Twitter.send(ni,tweetData)
        end)
end

def querySubscribedTo(userId, subscribers, tweetUserMap) do
   [{_, currentList}] = :ets.lookup(subscribers, userId)
  # IO.inspect currentList
    Enum.map(currentList, fn ni ->
         IO.inspect ni
          [{_, tweetList}] = :ets.lookup(tweetUserMap, ni)
           Enum.map(tweetList, fn n ->
            IO.inspect n
           end)
         #IO.inspect tweetList
         #Twitter.send(ni,tweetData)
        end)
end

def queryHashTags(hashTag, hashTagTweetMap, tweets) do
  [{_, currentList}] = :ets.lookup(hashTagTweetMap, hashTag)
  Enum.map(currentList, fn ni ->
         IO.inspect ni
          IO.inspect :ets.lookup(tweets, ni)
          
         #IO.inspect tweetList
         #Twitter.send(ni,tweetData)
        end)
end

def send(userId, tweetData) do
 #handle here
end



def main(args) do

users = :ets.new(:users, [:named_table,:public])

:ets.insert_new(users, {"1", ["user1","pwd_user1","user1@mail.com"]})
:ets.insert_new(users, {"2", ["user2","pwd_user2","user2@mail.com"]})
:ets.insert_new(users, {"3", ["user3","pwd_user3","user3@mail.com"]})
:ets.insert_new(users, {"4", ["user4","pwd_user4","user4@mail.com"]})
:ets.insert_new(users, {"5", ["user5","pwd_user5","user5@mail.com"]})

tweets = :ets.new(:tweets, [:named_table,:public])

:ets.insert_new(tweets, {"T1", ["#DOS project uses #GenServer"]})
:ets.insert_new(tweets, {"T2", ["#Elixir vs #Scala"]})
:ets.insert_new(tweets, {"T3", ["#Concurrency is main concept of #DOS"]})
:ets.insert_new(tweets, {"T4", ["DOS project 4"]})
:ets.insert_new(tweets, {"T5", ["DOS project 5"]})

#subscribers = bag.new()
#Bag.add_new!(subscribers, {})

subscribers = :ets.new(:subscribers, [:named_table,:public])

:ets.insert_new(subscribers, {"1", ["3","2","6"]})
:ets.insert_new(subscribers, {"2", ["6"]})
:ets.insert_new(subscribers, {"3", ["1","5"]})
:ets.insert_new(subscribers, {"4", ["5"]})
:ets.insert_new(subscribers, {"5", ["3","2"]})

subscribedTo = :ets.new(:subscribedTo, [:named_table,:public])

:ets.insert_new(subscribedTo, {"1", ["5","6"]})
:ets.insert_new(subscribedTo, {"2", ["1","3"]})
:ets.insert_new(subscribedTo, {"3", ["1","6"]})
:ets.insert_new(subscribedTo, {"4", ["2","3"]})
:ets.insert_new(subscribedTo, {"5", []})

tweetUserMap = :ets.new(:tweetUserMap, [:named_table,:public])

:ets.insert_new(tweetUserMap, {"1", ["T1","T5"]})
:ets.insert_new(tweetUserMap, {"2", ["T2","T6"]})
:ets.insert_new(tweetUserMap, {"3", ["T8"]})
:ets.insert_new(tweetUserMap, {"4", ["T4","T9"]})
:ets.insert_new(tweetUserMap, {"5", ["T3"]})

hashTags = :ets.new(:hashTags, [:named_table,:public])

:ets.insert_new(hashTags, { ["#DOS"],"H1"})
:ets.insert_new(hashTags, { ["#GenServer"],"H2"})
:ets.insert_new(hashTags, {["#Concurrency"],"H3"})
:ets.insert_new(hashTags, { ["#Elixir"],"H4"})
:ets.insert_new(hashTags, { ["#Scala"],"H5"})

hashTagTweetMap = :ets.new(:hashTagTweetMap, [:named_table,:public])

:ets.insert_new(hashTagTweetMap, {"H1", ["T1","T3"]})
:ets.insert_new(hashTagTweetMap, {"H2", ["T1"]})
:ets.insert_new(hashTagTweetMap, {"H3", ["T3"]})
:ets.insert_new(hashTagTweetMap, {"H4", ["T2"]})
:ets.insert_new(hashTagTweetMap, {"H5", ["T2"]})
 
  #IO.inspect length(users)
  #IO.inspect :ets.lookup(users, "2")

 Twitter.register("user6","pwd_user6","user6@gmail.com",users)
 #IO.inspect :ets.lookup(users, "6")

 #Twitter.tweet("3", "tweet1", subscribers)
 Twitter.querySubscribedTo("3",subscribers,tweetUserMap)

 #Twitter.queryHashTags("H1",hashTags,hashTagTweetMap, tweets)
 end

end
Twitter.main(System.argv())
