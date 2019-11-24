defmodule Twitter.Engine do
  use GenServer

  def send(userName, tweet, subscribers, users) do
    currentList = Twitter.Helper.readValue(:ets.lookup(subscribers, userName))
     #for each subscriber get tweets
    Enum.map(currentList, fn ni ->
       Twitter.Client.receive(ni, userName, tweet, users)
    end)
  end

  def start_node() do
    {:ok, pid} = GenServer.start_link(__MODULE__, :ok, [])
    pid
  end

  def init(:ok) do
  # {hashId, neighborMap} , {hashId, neighborMap}
  {:ok, 0}
  end
end
