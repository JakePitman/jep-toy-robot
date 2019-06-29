defmodule ToyRobot.RobotPositions do

  def start(state \\ %{}) do
    GenServer.start(ToyRobot.RobotPositions, state)
  end

  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  # callbacks

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  def handle_call({:get, key}, _from, state) do
    {:reply, Map.fetch!(state, key), state}
  end
end