defmodule Twitter do

  def main(args) do
    Twitter.Simulator.main(args)
  end
end
Twitter.main(System.argv())
