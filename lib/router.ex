defmodule ToyRobot.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  post "/move" do
    robot = GenServer.call(ToyRobot.Game.Robot, :move)
    send_resp(conn, 200, inspect(robot))
  end
end