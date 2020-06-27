defmodule Hyta.Boundary.GameSession do
  @moduledoc """
  Genserver that keeps the session of a Game
  """

  use GenServer

  alias Hyta.Core.{
    BoardInfo,
    Game
  }

  defstruct session: nil

  @name __MODULE__

  def child_spec(game_name) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [game_name]},
      restart: :temporary
    }
  end

  def start_link(game_name) do
    GenServer.start_link(__MODULE__, :ok, name: via(game_name))
  end

  def build_game(pid \\ @name, game_name, creator_player, board_size) do
    board_info = BoardInfo.new(board_size)

    GenServer.call(pid, {:build_game, game_name, creator_player, board_info})
  end

  def join_game(pid \\ @name, player_join) do
    GenServer.call(pid, {:join_game, player_join})
  catch
    :exit, {:noproc, _} -> {:error, :game_not_exists}
  end

  def start_game(pid \\ @name) do
    GenServer.call(pid, :start_game)
  end

  def move(pid \\ @name, player, x, y) do
    GenServer.call(pid, {:move, player, x, y})
  end

  def get_session(pid \\ @name) do
    GenServer.call(pid, :get_session)
  end

  def backdoor_set_game(pid \\ @name, game) do
    GenServer.call(pid, {:backdoor_set_game, game})
  end

  def init(:ok) do
    {:ok, %__MODULE__{}}
  end

  def handle_call({:build_game, game_name, creator_player, board_info}, _from, state) do
    game = Game.new(game_name, creator_player, board_info)

    {:reply, {:ok, game}, %{state | session: game}}
  end

  def handle_call({:join_game, player_join}, _from, state) do
    case Game.join(state.session, player_join) do
      {:ok, game} -> {:reply, {:ok, game}, %{state | session: game}}
      {:error, reason} -> {:reply, {:error, reason}, state}
    end
  end

  def handle_call(:start_game, _from, state) do
    case Game.start(state.session) do
      {:ok, game} -> {:reply, {:ok, game}, %{state | session: game}}
      {:error, reason} -> {:reply, {:error, reason}, state}
    end
  end

  def handle_call({:move, player, x, y}, _from, state) do
    case Game.move(state.session, player, x, y) do
      {:ok, game} -> {:reply, {:ok, game}, %{state | session: game}}
      {:empate, game} -> {:reply, {:empate, game}, %{state | session: game}}
      {:winner, game} -> {:reply, {:winner, game}, %{state | session: game}}
      {:error, reason} -> {:reply, {:error, reason}, state}
    end
  end

  def handle_call(:get_session, _from, state) do
    {:reply, state.session, state}
  end

  def handle_call({:backdoor_set_game, game}, _from, state) do
    new_state = %{state | session: game}

    {:reply, new_state, new_state}
  end

  defp via(game_name), do: {:via, Registry, {Hyta.Registry, game_name}}
end
