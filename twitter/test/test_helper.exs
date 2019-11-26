defmodule Twitter.Test.Helper do
  #create engine
  def createEngineAndClient do
    engine = Twitter.Engine.start_node()
    GenServer.call(engine, {:initDB})
    IO.inspect engine

    engine = Twitter.Engine.start_node()
    GenServer.call(engine, {:initDB})
    IO.inspect engine

    clients =  Enum.map(1..5, fn _ ->
          pid = Twitter.Client.start_node()
          GenServer.cast(pid, {:setEngine, engine})
          pid
        end)
    {engine, clients}
  end

  def createTestCase1(clients,engine) do
    count = 0
    passwd = "passwd"
    email = "user@abc.com"
    Enum.each(clients fn pid ->
      Twitter.Engine.insertUser(engine, pid, to_string(count), passwd, email})
      count = count + 1
    end)

    Genserver.call(engine,{:print})
  end
end
ExUnit.start()
