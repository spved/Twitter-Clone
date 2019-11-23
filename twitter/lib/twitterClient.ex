defmodule Twitter.Client do

def querySubscribedTo(userId, subscribers, tweetUserMap, tweets) do
   [{_, currentList}] = :ets.lookup(subscribers, userId)
  # IO.inspect currentList
    #for each subscriber get tweets
    subscribedTweets = List.flatten(Enum.map(currentList, fn ni ->
         #IO.inspect ni
          [{_, tweetList}] = :ets.lookup(tweetUserMap, ni)
           #get tweets for each tweet id
           stweets = Enum.map(tweetList, fn n ->
            [{_, stweet}] = :ets.lookup(tweets, n)
            stweet
           end)
       end))
       IO.inspect subscribedTweets
       subscribedTweets
    end
end
