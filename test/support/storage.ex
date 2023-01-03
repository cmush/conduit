defmodule Conduit.Storage do
  @doc """
  Reset the event store and read store databases.
  """
  def reset! do
    :ok = Application.stop(:conduit)

    reset_eventstore!()
    # reset_readstore!()

    {:ok, _} = Application.ensure_all_started(:conduit)
  end

  defp reset_eventstore! do
    {:ok, conn} =
      Conduit.EventStore.config()
      |> EventStore.Config.default_postgrex_opts()
      |> Postgrex.start_link()

    EventStore.Storage.Initializer.reset!(conn, Conduit.EventStore.config())
  end

  # defp reset_readstore! do
  #   {:ok, conn} = Postgrex.start_link(Conduit.Repo.config())

  #   Postgrex.query!(conn, truncate_readstore_tables(), [])
  # end

  # defp truncate_readstore_tables do
  #   """
  #   TRUNCATE TABLE
  #     accounts_users,
  #     projection_versions
  #   RESTART IDENTITY
  #   CASCADE;
  #   """
  # end
end
