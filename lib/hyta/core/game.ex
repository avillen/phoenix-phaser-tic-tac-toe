defmodule Hyta.Core.Game do
  @moduledoc """
  Game struct and logic
  """

  alias __MODULE__

  alias Hyta.Core.{
    BoardInfo,
    Player
  }

  @type name :: String.t()
  @type board_info :: BoardInfo.t()
  @type player :: Player.t()
  @type status :: :waiting_for_player | :ready | :started | :winner | :empate
  @type turn :: Player.t()

  @type t :: %Game{
          name: name,
          board_info: board_info,
          player_1: player,
          player_2: player | nil,
          status: status,
          turn: turn | nil
        }

  defstruct ~w(
    name
    board_info
    player_1
    player_2
    status
    turn
  )a

  @spec new(name, player, board_info) :: Game.t()
  def new(game_name, creator_player, board_info) do
    %Game{
      name: game_name,
      board_info: board_info,
      player_1: creator_player,
      player_2: nil,
      status: :waiting_for_player,
      turn: nil
    }
  end

  @spec join(Game.t(), player) :: {:ok, Game.t()} | {:error, :full_game}
  def join(%Game{player_2: nil} = game, player_join) do
    {:ok, %{game | player_2: player_join, status: :ready}}
  end

  def join(_, _), do: {:error, :full_game}

  @spec start(Game.t(), function()) :: {:ok, Game.t()} | {:error, :missing_players}
  def start(game, turn_func \\ &Enum.random/1)

  def start(%Game{player_1: player_1, player_2: player_2} = game, turn_func)
      when player_1 != nil and player_2 != nil do
    {:ok, %{game | status: :started, turn: turn_func.([player_1, player_2])}}
  end

  def start(_, _), do: {:error, :missing_players}

  @spec move(Game.t(), player, non_neg_integer(), non_neg_integer()) ::
          {:ok, Game.t()} | {:winner, Game.t()} | {:empate, Game.t()} | {:error, atom()}
  def move(
        %Game{
          status: :started,
          turn: curent_player,
          player_1: curent_player,
          player_2: next_player
        } = game,
        curent_player,
        x,
        y
      ) do
    do_move(game, next_player, x, y, "X")
  end

  def move(
        %Game{
          status: :started,
          turn: curent_player,
          player_1: next_player,
          player_2: curent_player
        } = game,
        curent_player,
        x,
        y
      ) do
    do_move(game, next_player, x, y, "O")
  end

  def move(%Game{status: :started}, _, _, _), do: {:error, :not_your_turn}
  def move(_, _, _, _), do: {:error, :not_started}

  defp do_move(game, next_player, x, y, value) do
    with {:ok, updated_game} <- move_in_board(game, x, y, value),
         :not_finished <- game_board_status(updated_game, value) do
      {:ok, change_turn(updated_game, next_player)}
    else
      {:winner, board} ->
        updated_game = %{board | status: :winner}
        {:winner, updated_game}

      {:empate, board} ->
        updated_game = %{board | status: :empate}
        {:empate, updated_game}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp move_in_board(game, x, y, value) do
    case BoardInfo.set(game.board_info, x, y, value) do
      {:ok, updated_board_info} -> {:ok, %{game | board_info: updated_board_info}}
      {:error, reason} -> {:error, reason}
    end
  end

  defp game_board_status(game, value) do
    with false <- game_board_full?(game.board_info),
         false <- game_winner?(game.board_info, value) do
      :not_finished
    else
      :empate -> {:empate, game}
      :winner -> {:winner, game}
    end
  end

  defp game_board_full?(board) do
    case BoardInfo.full?(board) do
      true -> :empate
      false -> false
    end
  end

  defp game_winner?(board, value) do
    case BoardInfo.line_full?(board, value) do
      true -> :winner
      false -> false
    end
  end

  defp change_turn(game, next_player), do: %{game | turn: next_player}
end
