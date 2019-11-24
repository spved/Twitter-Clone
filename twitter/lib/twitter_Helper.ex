defmodule Twitter.Helper do

def readValue([]) do
end

def readValue([{_,[]}]) do
  []
end

def readValue([{_,list}]) do
  list
end

def getSubscribers(userId, subscribers) do
  :ets.lookup(subscribers, userId)
end

def sendTweet(userId, tweet) do
  
end

def subscribe(userId1, userId2, subscribedTo, subscribers) do
  #userId1 is subscribing to userId2
  IO.inspect :ets.lookup(subscribers, userId2)
  [{_, user2Subscribers}] = :ets.lookup(subscribers, userId2)
  user2Subscribers = user2Subscribers ++ [userId1]
  :ets.insert(subscribers, {userId2, user2Subscribers})
  #:ets.update_counter(subscribers, userId2, user2Subscribers )

  [{_, user1SubscribedTo}] = :ets.lookup(subscribedTo, userId1)
  user1SubscribedTo = user1SubscribedTo ++ [userId2]
  :ets.insert(subscribedTo, {userId1, user2Subscribers})
 #:ets.update_counter(subscribedTo, userId1, user2Subscribers )

end

def addTweet(tweet,tweets,tableSize) do
[{_, size}] = :ets.lookup(tableSize, "tweets")
#IO.inspect :ets.info(tweets,size)
#IO.inspect length(tweets)
size = size + 1
IO.inspect size
tweetId = "T" <> "" <>Integer.to_string(size)
IO.inspect tweetId
:ets.insert_new(tweets, {tweetId, tweet})
end

def updateTweetUserMap(userId, tweetId, tweetUserMap) do
 #IO.inspect :ets.lookup(subscribers, userId2)
  [{_, userTweets}] = :ets.lookup(tweetUserMap, userId)
  userTweets = userTweets ++ [tweetId]
  :ets.insert(tweetUserMap, {userId, userTweets})

end

def updateMentionsUserMap(userId, tweetId, mentionUserMap) do
 #IO.inspect :ets.lookup(subscribers, userId2)
  [{_, userMentions}] = :ets.lookup(mentionUserMap, userId)
  userMentions = userMentions ++ [tweetId]
  :ets.insert(userMentions, {userId, userMentions})

end

def updateMentionsUserMap(hash, tweetId, hashTagTweetMap) do
 #IO.inspect :ets.lookup(subscribers, userId2)
  [{_, hashTagTweets}] = :ets.lookup(hashTagTweetMap, hash)
  hashTagTweets = hashTagTweets ++ [tweetId]
  :ets.insert(hashTagTweets, {hash, hashTagTweets})

end

def readTweet(tweets,tweetId, hashTagTweetMap, users, mentionUserMap) do
[{_, tweet}] = :ets.lookup(tweets, tweetId)
  #IO.inspect tweet
  #IO.inspect String.contains? tweet, "@"
  #IO.inspect String.contains? tweet, "#"

 if String.contains? tweet, "@" do
 tweetSplitMention = String.split(tweet, "@")
 #IO.inspect tweetSplitMention
 {_,tweetSplit1} = Enum.fetch(tweetSplitMention, 1)
 #IO.inspect tweetSplit1
 tweetMention = String.split(tweetSplit1, " ")
#tweetMention = Enum.fetch(tweetSplit1, 1)
 #IO.inspect Enum.fetch(tweetSplit, 1)
 #IO.inspect tweetMention
 {_,mention} = Enum.fetch(tweetMention, 0)
 #mention = "@" <> "" <> mention
 #IO.inspect mention
 if readValue(:ets.lookup(users, mention)) do
    #"valid user"

    if readValue(:ets.lookup(mentionUserMap, mention)) do
       # "user was mentioned before"
    userMentions = readValue(:ets.lookup(mentionUserMap, mention))
    
    #IO.inspect "userMentions"
    
    #IO.inspect userMentions
    userMentions = userMentions ++ [tweetId]

    #IO.inspect "user mentions after"
    #IO.inspect userMentions

    :ets.insert(mentionUserMap, {mention, userMentions})

 else
    #"user was never mentioned before, new entry"
    :ets.insert(mentionUserMap, {mention, [tweetId]})
 end

    else
    # "non existing user"
 end
 end
 if String.contains? tweet, "#" do
 tweetSplitHash = String.split(tweet, "#")
 #IO.inspect tweetSplitHash
 {_,tweetSplit2} = Enum.fetch(tweetSplitHash, 1)
 #IO.inspect tweetSplit2
 tweetHash = String.split(tweetSplit2, " ")
#tweetMention = Enum.fetch(tweetSplit1, 1)
 #IO.inspect Enum.fetch(tweetSplit, 1)
 #IO.inspect tweetHash
 {_,hash} = Enum.fetch(tweetHash, 0)
 hash = "#" <> "" <> hash
 IO.inspect hash
 IO.inspect :ets.lookup(hashTagTweetMap, hash)
 if readValue(:ets.lookup(hashTagTweetMap, hash)) do
    #IO.inspect "present"
    hashTagTweets = readValue(:ets.lookup(hashTagTweetMap, hash))
    hashTagTweets = hashTagTweets ++ [tweetId]
    :ets.insert(hashTagTweetMap, {hash, hashTagTweets})
 else
    #IO.inspect "new entry"
    :ets.insert(hashTagTweetMap, {hash, [tweetId]})
 end
 end
end

end

