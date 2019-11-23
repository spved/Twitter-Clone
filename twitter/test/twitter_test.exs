defmodule TwitterTest do
  use ExUnit.Case
  doctest Twitter

  IO.puts "Running Test"
  test "greets the world" do
    assert Twitter.hello() == :world
  end
end
