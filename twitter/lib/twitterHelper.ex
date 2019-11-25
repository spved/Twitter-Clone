defmodule Twitter.Helper do

def readValue([]) do
  []
end

def readValue(data) do
  [{ _ , list}] = data
  list
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

def isLogin(userName, engine) do
  List.last(GenServer.call(engine,{:getUser, userName}))
end




def readTweet(tweets,tweetId, engine) do
  tweet = readValue(:ets.lookup(tweets, tweetId))
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
 #def handle_cast({:addHashTagTweet, hashTag, tweetId}, state) do
 #Twitter.Helper.updateMentionsUserMap(mention, tweetId, mentionUserMap, users)
 GenServer.cast(engine,{:addMentionedTweet, mention, tweetId})
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
GenServer.cast(engine,{:addHashTagTweet, hash, tweetId})
#Twitter.Helper.updateHashTagTweetMap(hash, tweetId, hashTagTweetMap)
 end
end

end
