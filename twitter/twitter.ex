defmodule Twittert do
  use GenServer
  def main(args) do
    if Enum.count(args) != 2 do
      IO.puts(" Illegal Arguments Provided")
      System.halt(1)
    else
      numUsers = Enum.at(args, 0) |> String.to_integer()
      numTweets = Enum.at(args, 1) |> String.to_integer()

      engine = Twitter.Engine.start_node()
      GenServer.call(engine, {:initDB})
      IO.inspect engine

      clients =  Enum.map(1..numUsers, fn _ ->
            pid = Twitter.Client.start_node()
            GenServer.cast(pid, {:setEngine, engine})
            pid
          end)
          IO.inspect clients

          
          

      Twitter.Simulator.simulate(numUsers, numTweets, clients, engine)
    end
  end

  def init(init_arg) do
    {:ok, init_arg}
  end


end
Twittert.main(System.argv())
