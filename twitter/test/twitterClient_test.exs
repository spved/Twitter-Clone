defmodule TwitterClientTest do
  use ExUnit.Case
  doctest Twitter.Client



  IO.puts "Running Test"
  test "greets the world" do
    assert Twitter.hello() == :world
  end

  test "querySubscribedTo: Pass" do

    subscribers = :ets.new(:subscribers, [:named_table,:public])
    :ets.insert_new(subscribers, {"1", ["3","2","6"]})
    :ets.insert_new(subscribers, {"2", ["6"]})
    :ets.insert_new(subscribers, {"3", ["1","5"]})
    :ets.insert_new(subscribers, {"4", ["5"]})
    :ets.insert_new(subscribers, {"5", ["3","2"]})

    tweetUserMap = :ets.new(:tweetUserMap, [:named_table,:public])

    :ets.insert_new(tweetUserMap, {"1", ["T1","T5"]})
    :ets.insert_new(tweetUserMap, {"2", ["T2","T6"]})
    :ets.insert_new(tweetUserMap, {"3", ["T8"]})
    :ets.insert_new(tweetUserMap, {"4", ["T4","T9"]})
    :ets.insert_new(tweetUserMap, {"5", ["T3"]})

    tweets = :ets.new(:tweets, [:named_table,:public])

    :ets.insert_new(tweets, {"T1", "#DOS project uses #GenServer"})
    :ets.insert_new(tweets, {"T2", "#Elixir vs #Scala"})
    :ets.insert_new(tweets, {"T3", "#Concurrency is main concept of #DOS"})
    :ets.insert_new(tweets, {"T4", "DOS project 4"})
    :ets.insert_new(tweets, {"T5", "DOS project 5"})

    #"#DOS project uses #GenServer", "DOS project 5", "#Concurrency is main concept of #DOS"]
    assert Twitter.Client.querySubscribedTo("3",subscribers,tweetUserMap, tweets) == ["#DOS project uses #GenServer", "DOS project 5", "#Concurrency is main concept of #DOS"]
  end
end
