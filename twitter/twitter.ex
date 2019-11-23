defmodule Twitter do

def register(username,password,email,users) do
  #IO.inspect :ets.first(users)
  #IO.inspect :ets.lookup(users, "5")
  :ets.insert_new(users, {"user6", [username,password,email]})
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
         [{_, tweet}] = :ets.lookup(tweets,ni)
         IO.inspect tweet
        end)
end

def queryMentions(userId, mentionUserMap, tweets) do
  [{_, currentList}] = :ets.lookup(mentionUserMap, userId)
  Enum.map(currentList, fn ni ->
         IO.inspect ni
         [{_, tweet}] = :ets.lookup(tweets,ni)
         IO.inspect tweet
        end)
end

def send(userId, tweetData) do
 #handle here
end



def main(args) do

users = :ets.new(:users, [:named_table,:public])

:ets.insert_new(users, {"user1", ["user1","pwd_user1","user1@mail.com"]})
:ets.insert_new(users, {"user2", ["user2","pwd_user2","user2@mail.com"]})
:ets.insert_new(users, {"user3", ["user3","pwd_user3","user3@mail.com"]})
:ets.insert_new(users, {"user4", ["user4","pwd_user4","user4@mail.com"]})
:ets.insert_new(users, {"user5", ["user5","pwd_user5","user5@mail.com"]})

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
:ets.insert_new(subscribers, {"user3", ["user1","user5"]})
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
 
 #[{_, currentList}] = :ets.lookup(hashTagTweetMap, "#Concurrency")
#IO.inspect currentList
 
  #IO.inspect length(users)
  #IO.inspect :ets.lookup(users, "user2")

 Twitter.register("user6","pwd_user6","user6@gmail.com",users)
 #IO.inspect :ets.lookup(users, "user6")

 #Twitter.tweet("3", "tweet1", subscribers)
 #Twitter.querySubscribedTo("user3",subscribers,tweetUserMap)

 #Twitter.queryHashTags("#DOS",hashTagTweetMap, tweets)

 Twitter.queryMentions("user2", mentionUserMap, tweets)
 end

end
Twitter.main(System.argv())
