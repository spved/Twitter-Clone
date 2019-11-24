defmodule Twitter do

  def main(args) do
    if Enum.count(args) != 2 do
      IO.puts(" Illegal Arguments Provided")
      System.halt(1)
    else
      numUsers = Enum.at(args, 0) |> String.to_integer()
      numTweets = Enum.at(args, 1) |> String.to_integer()

    engine = Twitter.Engine.start_node()
    IO.inspect engine

    clients =  Enum.map(1..numUsers, fn _ ->
          pid = Twitter.Client2.start_node()
          pid
        end)
        IO.inspect clients

    Twitter.Simulator.main(args)
  end
end
Twitter.main(System.argv())
