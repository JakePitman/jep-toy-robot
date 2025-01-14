defmodule ToyRobotTest do
  use ExUnit.Case
  doctest ToyRobot

  describe "move" do
    test "#move moves west when dir == 'WEST'" do
      assert ToyRobot.move(%ToyRobot{north: 0, east: 3, dir: "WEST"}) == %ToyRobot{north: 0, east: 2, dir: "WEST"}
    end
    test "#move moves south when dir == 'SOUTH'" do
      assert ToyRobot.move(%ToyRobot{north: 3, east: 0, dir: "SOUTH"}) == %ToyRobot{north: 2, east: 0, dir: "SOUTH"}
    end
  end


  test "#check_boundary returns {:ok, position} when not facing boundary" do
    position = %ToyRobot{north: 0, east: 0, dir: "NORTH"}
    assert ToyRobot.check_boundary(position) == {:ok, position}
  end
  test "#check_boundary returns {:error, message, position} when not facing boundary" do
    position = %ToyRobot{north: 4, east: 0, dir: "NORTH"}
    assert ToyRobot.check_boundary(position) == {:error, "Facing boundary, cannot move", position}
  end
end
