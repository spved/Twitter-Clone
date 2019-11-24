defmodule Twitter.Client2 do
  use GenServer

  def start_node() do
    {:ok, pid} = GenServer.start_link(__MODULE__, :ok, [])
    pid
  end

  def init(:ok) do
  # {hashId, neighborMap} , {hashId, neighborMap}
  {:ok, 0}
  end
end
