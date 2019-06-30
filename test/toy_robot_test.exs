defmodule ToyRobotTest do
  use ExUnit.Case
  doctest ToyRobot

  describe "#move" do
    test "moves north when dir == 'NORTH'" do
      {:ok, robot} = ToyRobot.RobotPositions.start()
      ToyRobot.move(robot)
      assert ToyRobot.RobotPositions.get(robot, :north) == 1
    end
    test "moves south when dir == 'SOUTH'" do
      {:ok, robot} = ToyRobot.RobotPositions.start(%ToyRobot{north: 3, east: 0, dir: "SOUTH"})
      ToyRobot.move(robot)
      assert ToyRobot.RobotPositions.get(robot, :north) == 2
    end
    test "moves south when dir == 'EAST'" do
      {:ok, robot} = ToyRobot.RobotPositions.start(%ToyRobot{north: 0, east: 0, dir: "EAST"})
      ToyRobot.move(robot)
      assert ToyRobot.RobotPositions.get(robot, :east) == 1
    end
    test "moves west when dir == 'WEST'" do
      {:ok, robot} = ToyRobot.RobotPositions.start(%ToyRobot{north: 0, east: 3, dir: "WEST"})
      ToyRobot.move(robot)
      assert ToyRobot.RobotPositions.get(robot, :east) == 2
    end
  end


  describe "#check_boundary" do
    test "returns {:ok, position} when not facing boundary" do
      {:ok, robot} = ToyRobot.RobotPositions.start()
      assert ToyRobot.check_boundary(robot) == {:ok, robot}
    end
    test "returns {:error, message, position} when not facing boundary" do
      {:ok, robot} = ToyRobot.RobotPositions.start(%{north: 4, east: 0, dir: "NORTH"})
      assert ToyRobot.check_boundary(robot) == {:error, "Facing boundary, cannot move", robot}
    end
  end

  describe "#report" do
    test "#report returns the robot passed as arg" do
      {:ok, robot} = ToyRobot.RobotPositions.start(%ToyRobot{north: 1, east: 2, dir: "WEST"})
      assert ToyRobot.report(robot) == robot
    end
  end

  describe "#rotate" do
    test "turns the robot's position 90 degrees left or right" do
        {:ok, robot} = ToyRobot.RobotPositions.start
        ToyRobot.rotate(robot, "LEFT")
        assert ToyRobot.RobotPositions.get(robot, :dir) == "WEST"


        {:ok, robot} = ToyRobot.RobotPositions.start(%{north: 0, east: 0, dir: "EAST"})
        ToyRobot.rotate(robot, "RIGHT")
        assert ToyRobot.RobotPositions.get(robot, :dir) == "SOUTH"
    end
  end

  describe "#place" do

    test "places the position on a new set of coordinates" do
      {:ok, robot} = ToyRobot.RobotPositions.start
      ToyRobot.place(robot, "3,3,NORTH")
      assert ToyRobot.RobotPositions.get(robot, :north) == 3
      assert ToyRobot.RobotPositions.get(robot, :east) == 3
      assert ToyRobot.RobotPositions.get(robot, :dir) == "NORTH"
    end
    test "Reverts back to prev. position when given invalid DIR" do
      {:ok, robot} = ToyRobot.RobotPositions.start
      ToyRobot.place(robot, "3,3,NurTH")
      assert ToyRobot.RobotPositions.get(robot, :north) == 0
      assert ToyRobot.RobotPositions.get(robot, :east) == 0
      assert ToyRobot.RobotPositions.get(robot, :dir) == "NORTH"
    end
    test "Reverts back to prev. position when given coord outside boundary" do
      {:ok, robot} = ToyRobot.RobotPositions.start
      ToyRobot.place(robot, "3,9001,NORTH")
      assert ToyRobot.RobotPositions.get(robot, :north) == 0
      assert ToyRobot.RobotPositions.get(robot, :east) == 0
      assert ToyRobot.RobotPositions.get(robot, :dir) == "NORTH"
    end
    test "Reverts back to prev. position when wEirD syntax" do
      {:ok, robot} = ToyRobot.RobotPositions.start
      ToyRobot.place(robot, "3.3,NORTH")
      assert ToyRobot.RobotPositions.get(robot, :north) == 0
      assert ToyRobot.RobotPositions.get(robot, :east) == 0
      assert ToyRobot.RobotPositions.get(robot, :dir) == "NORTH"
    end
  end
end
