defmodule TwitterClientTest do
  use ExUnit.Case
  doctest Twitter.Client

  IO.puts "Running Test"

  test "register user" do
      {engine, clients} = Twitter.Test.Helper.createEngineAndClient()
      passwd = "passwd"
      email = "user@abc.com"
      user = "user"
      pid = Enum.at(clients, 0)
      Twitter.Engine.insertUser(engine, pid, user, passwd, email)
      assert :ets.lookup(:users, user) == [{user, [pid, passwd, email, 0]}]
  end

  test "register user duplicate" do
      {engine, clients} = Twitter.Test.Helper.createEngineAndClient()
      passwd = "passwd"
      email = "user@abc.com"
      user = "user"
      pid = Enum.at(clients, 0)
      Twitter.Engine.insertUser(engine, pid, user, passwd, email)
      passwd2 = "passwd2"
      email2 = "user2@abc.com"
      Twitter.Engine.insertUser(engine, pid, user, passwd2, email2)
      assert :ets.lookup(:users, user) == [{user, [pid, passwd, email, 0]}]
  end

  test "querySubscribedTo: Pass" do
    {engine, clients} = Twitter.Test.Helper.createEngineAndClient()
    Twitter.Test.Helper.createTestCase1(engine, clients)
    IO.inspect GenServer.call(Enum.at(clients,1), {:querySubscribedTo, 4}), label: "querySubscribedTo"
  end
end
