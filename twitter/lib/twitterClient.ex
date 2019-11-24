defmodule Twitter.Client do

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
end
