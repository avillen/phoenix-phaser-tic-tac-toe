defmodule Hyta.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      HytaWeb.Telemetry,
      {DynamicSupervisor, name: Hyta.DynamicSupervisor, strategy: :one_for_one},
      {Registry, [keys: :unique, name: Hyta.Registry]},
      {Phoenix.PubSub, name: Hyta.PubSub},
      HytaWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Hyta.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    HytaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
