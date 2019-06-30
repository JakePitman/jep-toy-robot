require IEx
#source config/.env

defmodule ToyRobot do

  @boundary_range 0..4
  @lower_boundary Enum.to_list(@boundary_range) |> Enum.at(0)
  @upper_boundary Enum.to_list(@boundary_range) |> Enum.at(-1)

  defstruct [:north, :east, :dir]

  def check_boundary(robot) do
    east = ToyRobot.RobotPositions.get(robot, :east)
    north = ToyRobot.RobotPositions.get(robot, :north)
    dir = ToyRobot.RobotPositions.get(robot, :dir)

    cond do
      (east == @upper_boundary && dir == "EAST") ||
      (east == @lower_boundary && dir == "WEST") ||
      (north == @upper_boundary && dir == "NORTH") ||
      (north == @lower_boundary && dir == "SOUTH") ->
        {:error, "Facing boundary, cannot move", robot}
      true ->
        {:ok, robot}
    end
  end
  

  @doc """
  Moves one space forward & returns new pos if check_boundary passes. Returns current pos if check_boundary fails
  ## Examples
      iex> {:ok, robot} = ToyRobot.RobotPositions.start()
      iex> ToyRobot.move(robot)
      iex> ToyRobot.RobotPositions.get(robot, :north)
      1

      iex> {:ok, robot} = ToyRobot.RobotPositions.start(%ToyRobot{north: 0, east: 4, dir: "EAST"})
      iex> ToyRobot.move(robot)
      iex> ToyRobot.RobotPositions.get(robot, :east)
      4
  """
  def move(robot) when is_pid(robot) do
    check_boundary(robot)
    |> move()
  end

  def move({:ok, robot}) do
    case ToyRobot.RobotPositions.get(robot, :dir) do
      "NORTH" ->
        ToyRobot.RobotPositions.put(robot, :north, ToyRobot.RobotPositions.get(robot, :north) + 1)
      "SOUTH" ->
        ToyRobot.RobotPositions.put(robot, :north, ToyRobot.RobotPositions.get(robot, :north) - 1)
      "EAST" ->
        ToyRobot.RobotPositions.put(robot, :east, ToyRobot.RobotPositions.get(robot, :east) + 1)
      "WEST" ->
        ToyRobot.RobotPositions.put(robot, :east, ToyRobot.RobotPositions.get(robot, :east) - 1)
    end
    robot
  end

  def move({:error, message, position}) do
    IO.puts(message)
    position
  end


  def rotate(robot, "LEFT") do
    new_dir = case ToyRobot.RobotPositions.get(robot, :dir) do
      "NORTH" -> "WEST"
      "WEST" -> "SOUTH"
      "SOUTH" -> "EAST"
      "EAST" -> "NORTH"
    end
    ToyRobot.RobotPositions.put(robot, :dir, new_dir)
    robot
  end

  def rotate( robot, "RIGHT") do
    new_dir = case ToyRobot.RobotPositions.get(robot, :dir) do
      "NORTH" -> "EAST"
      "WEST" -> "NORTH"
      "SOUTH" -> "WEST"
      "EAST" -> "SOUTH"
    end
    ToyRobot.RobotPositions.put(robot, :dir, new_dir)
    robot
  end

  def place(robot, string_command ) do
    string_to_map_result = string_command_to_map(string_command)
    case string_to_map_result do
      {:ok, coord} ->
        if Enum.member?(@boundary_range, coord[:east]) && Enum.member?(@boundary_range, coord[:north]) do
          ToyRobot.RobotPositions.put(robot, :north, coord[:north])
          ToyRobot.RobotPositions.put(robot, :east, coord[:east])
          ToyRobot.RobotPositions.put(robot, :dir, coord[:dir])
          robot
        else
          IO.puts("Invalid PLACE coordinates" )
          IO.puts("Reverting to previous position" )
          robot
        end
      {:error, message} ->
        IO.puts(message)
        IO.puts("Reverting to previous position" )
        robot
    end
  end

  defp string_command_to_map(string_command) do
    if Regex.match?(~r/\d,\d,(NORTH|SOUTH|EAST|WEST)/, string_command) do
      split_string = String.split(string_command, ",")
      east = Enum.at(split_string, 0) |> String.to_integer
      north = Enum.at(split_string, 1) |> String.to_integer
      dir = Enum.at(split_string, 2)
      {:ok, %{east: east, north: north, dir: dir}}
    else
      {:error, "Invalid PLACE coordinates"}
    end
  end

  def report(robot) when is_pid(robot) do
    IO.puts "Robot is at position #{ToyRobot.RobotPositions.get(robot, :east)}, #{ToyRobot.RobotPositions.get(robot, :north)}, facing: #{ToyRobot.RobotPositions.get(robot, :dir)}"
    robot
  end

end
