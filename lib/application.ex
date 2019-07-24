defmodule ToyRobot.Application do
  use Application

  def start(_type, args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: ToyRobot.Router, options: [port: 8080]},
      {ToyRobot.Game.Robot, %ToyRobot{north: args[:north], east: args[:east], dir: args[:dir]}}
    ]


    opts = [strategy: :one_for_one, name: ToyRobot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end