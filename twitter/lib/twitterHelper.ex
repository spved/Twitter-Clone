defmodule Twitter.Helper do

def readValue([]) do
  []
end

def readValue(data) do
  [{ _ , list}] = data
  list
end

def getSubscribers(userId, subscribers) do
 [{_, userSubscribers}] = :ets.lookup(subscribers, userId)
 userSubscribers
end

def sendTweet(userId, tweet) do

end

def validateUser([]) do
  false
end
def validateUser(_) do
  true
end

def validateUser(userName, users) do
  validateUser(readValue(:ets.lookup(users, userName)))
end

def login(userName, password, users) do
  if validateUser(userName, users) do
    list = readValue(:ets.lookup(users, userName))
    userPassword = List.first(list)
    if userPassword == password do
      :ets.insert(users, {userName, List.replace_at(list, 2, "1")})
    end
  end
end

def logout(userName, users) do
  if validateUser(userName, users) do
    list = readValue(:ets.lookup(users, userName))
    :ets.insert(users, {userName, List.replace_at(list, 2, "0")})
  end
end

def isLogin(userName, users) do
  List.last(readValue(:ets.lookup(users, userName)))
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

def updateMentionsUserMap(mention, tweetId, mentionUserMap, users) do
 #IO.inspect :ets.lookup(subscribers, userId2)
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



def updateHashTagTweetMap(hash, tweetId, hashTagTweetMap) do
 #IO.inspect :ets.lookup(subscribers, userId2)
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
 Twitter.Helper.updateMentionsUserMap(mention, tweetId, mentionUserMap, users)
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

# IO.inspect hash
# IO.inspect :ets.lookup(hashTagTweetMap, hash)
Twitter.Helper.updateHashTagTweetMap(hash, tweetId, hashTagTweetMap)
 end
end

end
