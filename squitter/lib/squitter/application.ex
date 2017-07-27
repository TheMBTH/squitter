defmodule Squitter.Application do
  @moduledoc false

  use Application
  import Supervisor.Spec, warn: false

  def start(_type, _args) do

    :pg2.create(:aircraft)

    children = [
      registry_supervisor(Squitter.AircraftRegistry, :unique),
      supervisor(Squitter.AircraftSupervisor, []),
      supervisor(Squitter.DecodingSupervisor, [])
    ]

    opts = [strategy: :one_for_one, name: Squitter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp registry_supervisor(name, keys) do
    supervisor(Registry, [keys, name, [partitions: System.schedulers_online()]], id: name)
  end
end