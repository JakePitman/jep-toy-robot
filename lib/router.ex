defmodule ToyRobot.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  post "/move" do
    robot = GenServer.call(ToyRobot.Game.Robot, :move)
    send_resp(conn, 200, inspect(robot))
  end

  post "/rotate_left" do
    robot = GenServer.call(ToyRobot.Game.Robot, :rotate_left)
    send_resp(conn, 200, inspect(robot))
  end

  post "/rotate_right" do
    robot = GenServer.call(ToyRobot.Game.Robot, :rotate_right)
    send_resp(conn, 200, inspect(robot))
  end

  post "/place/:coords" do
    robot = GenServer.call(ToyRobot.Game.Robot, {:place, coords})
    send_resp(conn, 200, inspect(robot))
  end

  post "/report" do
    robot = GenServer.call(ToyRobot.Game.Robot, :report)
    send_resp(conn, 200, inspect(robot))
  end

end