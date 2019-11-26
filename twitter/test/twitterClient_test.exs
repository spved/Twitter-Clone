defmodule TwitterClientTest do
  use ExUnit.Case
  doctest Twitter.Client



  IO.puts "Running Test"
  test "greets the world" do
    assert Twitter.hello() == :world
  end

  test "querySubscribedTo: Pass" do
    {engine, client} = createEngineAndClient()

  end
end
