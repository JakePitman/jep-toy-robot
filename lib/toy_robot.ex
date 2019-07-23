require IEx
#source config/.env

defmodule ToyRobot do

  @boundary_range 0..4
  @lower_boundary Enum.to_list(@boundary_range) |> Enum.at(0)
  @upper_boundary Enum.to_list(@boundary_range) |> Enum.at(-1)

  defstruct [:north, :east, :dir]

  @moduledoc """
  Documentation for ToyRobot.
  """

  @doc """
  checks if robot is facing boundary, returns :ok if robot can move forward, :error if can't
  ## Examples
      iex> ToyRobot.check_boundary(%ToyRobot{north: 0, east: 0, dir: "NORTH"})
      {:ok, %ToyRobot{north: 0, east: 0, dir: "NORTH"}}

      iex> ToyRobot.check_boundary(%ToyRobot{north: 0, east: 0, dir: "WEST"})
      {:error, "Facing boundary, cannot move", %ToyRobot{north: 0, east: 0, dir: "WEST"}}
  """
  def check_boundary(%ToyRobot{north: @upper_boundary, dir: "NORTH"} = position) do
    {:error, "Facing boundary, cannot move", position}
  end

  def check_boundary(%ToyRobot{north: @lower_boundary, dir: "SOUTH"} = position) do
    {:error, "Facing boundary, cannot move", position}
  end

  def check_boundary(%ToyRobot{east: @upper_boundary, dir: "EAST"} = position) do
    {:error, "Facing boundary, cannot move", position}
  end

  def check_boundary(%ToyRobot{east: @lower_boundary, dir: "WEST"} = position) do
    {:error, "Facing boundary, cannot move", position}
  end

  def check_boundary(%ToyRobot{} = position) do
    {:ok, position}
  end
  

  @doc """
  Moves one space forward & returns new pos if check_boundary passes. Returns current pos if check_boundary fails
  ## Examples
      iex> ToyRobot.move(%ToyRobot{north: 0, east: 0, dir: "NORTH"})
      %ToyRobot{north: 1, east: 0, dir: "NORTH"}

      iex> %ToyRobot{north: 0, east: 4, dir: "EAST"} |> ToyRobot.move
      %ToyRobot{north: 0, east: 4, dir: "EAST"}
  """
  def move(position) when is_map(position) do
    check_boundary(position)
    |> move()
  end

  def move({:ok, %ToyRobot{north: north, dir: "NORTH"} = position}) do
    %{ position | north: north + 1 }
  end

  def move({:ok, %ToyRobot{east: east, dir: "EAST"} = position}) do
    %{position | east: east + 1}
  end

  def move({:ok, %ToyRobot{east: east, dir: "WEST"} = position}) do
    %{position | east: east - 1}
  end

  def move({:ok, %ToyRobot{north: north, dir: "SOUTH"} = position}) do
    %{position | north: north - 1}
  end

  def move({:error, message, position}) do
    IO.puts(message)
    position
  end

  @doc """
  Rotates position's dir property left or right by 90deg
  ## Examples
      iex> ToyRobot.rotate(%{north: 0, east: 0, dir: "NORTH"}, "LEFT")
      %{north: 0, east: 0, dir: "WEST"}

      iex> ToyRobot.rotate(%{north: 0, east: 0, dir: "EAST"}, "RIGHT")
      %{north: 0, east: 0, dir: "SOUTH"}
  """

  def rotate( %{dir: dir} = position, "LEFT") do
    new_dir = case dir do
      "NORTH" -> "WEST"
      "WEST" -> "SOUTH"
      "SOUTH" -> "EAST"
      "EAST" -> "NORTH"
    end
    %{ position | dir: new_dir }
  end

  def rotate( %{dir: dir} = position, "RIGHT") do
    new_dir = case dir do
      "NORTH" -> "EAST"
      "WEST" -> "NORTH"
      "SOUTH" -> "WEST"
      "EAST" -> "SOUTH"
    end
    %{ position | dir: new_dir }
  end


  @doc """
  Places the position to a new set of coordinates
  Reverts back to prev. position when given invalid coordinates
  ## Examples
    iex> ToyRobot.place( %ToyRobot{north: 1, east: 1, dir: "EAST"}, "3,3,NORTH")
    %ToyRobot{north: 3, east: 3, dir: "NORTH"}
  """

  def place(previous_position, string_command) do
    string_to_map_result = string_command_to_map(string_command)
    case string_to_map_result do
      {:ok, coord} ->
        if Enum.member?(@boundary_range, coord[:east]) && Enum.member?(@boundary_range, coord[:north]) do
          %ToyRobot{ north: coord[:north], east: coord[:east], dir: coord[:dir] }
        else
          IO.puts("Invalid PLACE coordinates" )
          IO.puts("Reverting to previous position" )
          previous_position
        end
      {:error, message} ->
        IO.puts(message)
        IO.puts("Reverting to previous position" )
        previous_position
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

  @doc """
  Takes, outputs, and then returns a position
  #Examples
  iex> ToyRobot.report(%ToyRobot{north: 1, east: 2, dir: "WEST"})
  %ToyRobot{north: 1, east: 2, dir: "WEST"}
  """
  def report(%ToyRobot{north: north, east: east, dir: dir} = position) do
    IO.puts "Robot is at position #{east}, #{north}, facing: #{dir}"
    position
  end

end
