defmodule ToyRobot.CLI do
  def main([filename]) do
    if File.exists?(filename) do
      filename
      |> read_commands
      |> run_commands
    else
      IO.puts "#{filename} does not exist"
    end
  end

  defp read_commands(filename) do
    File.stream!(filename)
    |> Enum.to_list
    |> Enum.map(&String.trim/1)
  end

  # run_commands/1
  defp run_commands(commands) do
    run_commands(commands, %ToyRobot{north: 0, east: 0, dir: "NORTH"})
  end

  # run_commands/2
  def run_commands(["MOVE" | commands], position) do
    run_commands(commands, position
    |> ToyRobot.move)
  end

  def run_commands(["LEFT" | commands], position) do
    run_commands(commands, position
    |> ToyRobot.rotate("LEFT"))
  end

  def run_commands(["RIGHT" | commands], position) do
    run_commands(commands, position
    |> ToyRobot.rotate("RIGHT"))
  end

  def run_commands(["PLACE," <> coords | commands], position) do
    run_commands(commands, position
    |> ToyRobot.place(coords))
  end

  def run_commands(["REPORT" | commands], position) do
    run_commands(commands, position
    |> ToyRobot.report)
  end

  def run_commands([], %ToyRobot{} = position) do
    ToyRobot.report(position)
  end
end
