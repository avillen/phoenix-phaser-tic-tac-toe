defmodule Hyta do
  @moduledoc """
  Hyta API. Contains the business logic
  """

  alias Hyta.Boundary.GameSession

  alias Hyta.Core.{
    Game,
    Player
  }

  @spec create_game(Game.name(), Player.t(), non_neg_integer()) ::
          {:ok, Game.t()} | {:error, atom()}
  def create_game(game_name, player, board_size \\ 3) do
    with {:ok, pid} <-
           DynamicSupervisor.start_child(Hyta.DynamicSupervisor, {GameSession, game_name}),
         {:ok, game} <- GameSession.build_game(pid, game_name, player, board_size) do
      {:ok, game}
    else
      {:error, {:already_started, _pid}} -> {:error, :already_started}
      {:error, reason} -> {:error, reason}
    end
  end

  @spec join_game(Game.name(), Player.t()) :: {:ok, Game.t()} | {:error, atom()}
  def join_game(game_name, player) do
    with {:ok, _game} <- GameSession.join_game(via_tuple(game_name), player),
         {:ok, game} <- GameSession.start_game(via_tuple(game_name)) do
      {:ok, game}
    end
  end

  @spec move(Game.name(), Player.t(), non_neg_integer(), non_neg_integer()) ::
          {:ok, Game.t()} | {:winner, Game.t()} | {:empate, Game.t()} | {:error, atom()}
  def move(game_name, player, x, y) do
    case GameSession.move(via_tuple(game_name), player, x, y) do
      {:ok, game} ->
        {:ok, game}

      {:winner, game} ->
        DynamicSupervisor.terminate_child(Hyta.DynamicSupervisor, pid_by_name(game_name))
        {:winner, game}

      {:empate, game} ->
        DynamicSupervisor.terminate_child(Hyta.DynamicSupervisor, pid_by_name(game_name))
        {:empate, game}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec get_game(Game.name()) :: Game.t()
  def get_game(game_name) do
    GameSession.get_session(via_tuple(game_name))
  end

  defp pid_by_name(game_name), do: game_name |> via_tuple() |> GenServer.whereis()
  defp via_tuple(game_name), do: {:via, Registry, {Hyta.Registry, game_name}}
end
