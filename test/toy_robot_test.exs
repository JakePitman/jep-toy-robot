defmodule ToyRobotTest do
  use ExUnit.Case
  doctest ToyRobot

  describe "move" do
    test "#move moves west when dir == 'WEST'" do
      {:ok, robot} = ToyRobot.RobotPositions.start()
      ToyRobot.move(robot)
      assert ToyRobot.RobotPositions.get(robot, :north) == 1
    end
    test "#move moves south when dir == 'SOUTH'" do
      {:ok, robot} = ToyRobot.RobotPositions.start(%ToyRobot{north: 3, east: 0, dir: "SOUTH"})
      ToyRobot.move(robot)
      assert ToyRobot.RobotPositions.get(robot, :north) == 2
    end
  end


  test "#check_boundary returns {:ok, position} when not facing boundary" do
    {:ok, robot} = ToyRobot.RobotPositions.start()
    assert ToyRobot.check_boundary(robot) == {:ok, robot}
  end
  test "#check_boundary returns {:error, message, position} when not facing boundary" do
    {:ok, robot} = ToyRobot.RobotPositions.start(%{north: 4, east: 0, dir: "NORTH"})
    assert ToyRobot.check_boundary(robot) == {:error, "Facing boundary, cannot move", robot}
  end

  test "#report returns the robot passed as arg" do
    {:ok, robot} = ToyRobot.RobotPositions.start(%ToyRobot{north: 1, east: 2, dir: "WEST"})
    assert ToyRobot.report(robot) == robot
  end
end
