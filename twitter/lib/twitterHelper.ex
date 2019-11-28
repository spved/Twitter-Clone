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

def validateUser([{_,_}]) do
  true
end

def validateUser(userName) do
  validateUser(readValue(:ets.lookup(:users, userName)))
end

def isLogin(userName, engine) do
  List.last(GenServer.call(engine,{:getUser, userName}))
end




def readTweet(tweet,tweetId, engine) do
   if String.contains? tweet, "@" do
   tweetSplitMention = String.split(tweet, "@")
   #IO.inspect tweetSplitMention
   {_,tweetSplit1} = Enum.fetch(tweetSplitMention, 1)
   #IO.inspect tweetSplit1
   tweetMention = String.split(tweetSplit1, " ")

   {_,mention} = Enum.fetch(tweetMention, 0)

   GenServer.cast(engine,{:addMentionedTweet, mention, tweetId})
   end

   if String.contains? tweet, "#" do
   tweetSplitHash = String.split(tweet, "#")
   {_,tweetSplit2} = Enum.fetch(tweetSplitHash, 1)
   #IO.inspect tweetSplit2
   tweetHash = String.split(tweetSplit2, " ")

   {_,hash} = Enum.fetch(tweetHash, 0)
   hash = "#" <> "" <> hash

   GenServer.cast(engine,{:addHashTagTweet, hash, tweetId})
 end
end

end
