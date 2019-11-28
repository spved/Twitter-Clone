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
    tweets = GenServer.call(Enum.at(clients,2), {:querySubscribedTo})
    assert tweets == ["tweet 1 #tweet1 @1 @2","tweet 3 #tweet3 #tweet2 @3 @2 @2","tweet 3 #tweet3 #tweet2 @3 @2 @2"]
  end

  test "querySubscribedTo: No subscribers" do
    {engine, clients} = Twitter.Test.Helper.createEngineAndClient()
    Twitter.Test.Helper.createTestCase1(engine, clients)
    tweets = GenServer.call(Enum.at(clients,0), {:querySubscribedTo})
    assert tweets == []
  end

  test "querySubscribedTo: subscribers have no tweets" do
    {engine, clients} = Twitter.Test.Helper.createEngineAndClient()
    Twitter.Test.Helper.createTestCase1(engine, clients)
    tweets = GenServer.call(Enum.at(clients,3), {:querySubscribedTo})
    assert tweets == []
  end

  test "queryHashtags: pass" do
    {engine, clients} = Twitter.Test.Helper.createEngineAndClient()
    Twitter.Test.Helper.createTestCase1(engine, clients)
    tweets = GenServer.call(Enum.at(clients,0), {:queryHashTags, "tweet2"})
    assert tweets == ["tweet 2 #tweet2 @2 @3","tweet 3 #tweet3 #tweet2 @3 @2 @2"]
  end

  test "queryHashtags: hashtag not present" do
    {engine, clients} = Twitter.Test.Helper.createEngineAndClient()
    Twitter.Test.Helper.createTestCase1(engine, clients)
    tweets = GenServer.call(Enum.at(clients,0), {:queryHashTags, "yesgowell"})
    assert tweets == []
  end

  test "queryMentionedIn: pass" do
    {engine, clients} = Twitter.Test.Helper.createEngineAndClient()
    Twitter.Test.Helper.createTestCase1(engine, clients)
    tweets = GenServer.call(Enum.at(clients,2), {:queryMentions})
    assert tweets == ["tweet 2 #tweet2 @2 @3", "tweet 3 #tweet3 #tweet2 @3 @2 @2", "tweet 1 #tweet1 @1 @2"]
  end
end
