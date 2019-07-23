defmodule ToyRobot.Game.Robot do

  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(%ToyRobot{north: north, east: east, dir: dir}) do
    {:ok, %ToyRobot{north: north, east: east, dir: dir}}
  end

  def handle_call(:move, _from, robot) do
    new_robot = robot |> ToyRobot.move
    {:reply, new_robot, new_robot}
  end

  def handle_call(:rotate_left, _from, robot) do
    new_robot = robot |> ToyRobot.rotate("LEFT")
    {:reply, new_robot, new_robot}
  end

  def handle_call(:rotate_right, _from, robot) do
    new_robot = robot |> ToyRobot.rotate("RIGHT")
    {:reply, new_robot, new_robot}
  end

  def handle_call({:place, string_command}, _from, robot) do
    new_robot = ToyRobot.place(robot, string_command)
    {:reply, new_robot, new_robot}
  end

  def handle_call(:report, _from, robot) do
    ToyRobot.report(robot)
    {:reply, robot, robot}
  end

end