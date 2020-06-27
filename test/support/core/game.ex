defmodule Hyta.Support.Core.Game do
  @moduledoc """
  Support module to build Game related data
  """

  alias Hyta.Core.Game

  import Hyta.Support.Shared, only: [build_random_string: 0]
  import Hyta.Support.Core.Player, only: [build_player: 0]
  import Hyta.Support.Core.BoardInfo, only: [build_board_info: 0]

  @status ~w(waiting_for_player ready started winner empate)a

  def build_game(attrs \\ []) do
    player_1 = Keyword.get(attrs, :player_1, build_player())
    player_2 = Keyword.get(attrs, :player_2, build_player())

    %Game{
      name: Keyword.get(attrs, :name, build_random_string()),
      board_info: Keyword.get(attrs, :board_info, build_board_info()),
      player_1: player_1,
      player_2: player_2,
      status: Keyword.get(attrs, :status, Enum.random(@status)),
      turn: Keyword.get(attrs, :turn, Enum.random([player_1, player_2]))
    }
  end

  def build_new_game(attrs \\ []) do
    player = Keyword.get(attrs, :player_1, build_player())

    %Game{
      name: Keyword.get(attrs, :name, build_random_string()),
      board_info: Keyword.get(attrs, :board_info, build_board_info()),
      player_1: player,
      player_2: nil,
      status: :waiting_for_player,
      turn: nil
    }
  end

  def build_ready_game(attrs \\ []) do
    player_1 = Keyword.get(attrs, :player_1, build_player())
    player_2 = Keyword.get(attrs, :player_2, build_player())

    %Game{
      name: Keyword.get(attrs, :name, build_random_string()),
      board_info: Keyword.get(attrs, :board_info, build_board_info()),
      player_1: player_1,
      player_2: player_2,
      status: :ready,
      turn: nil
    }
  end

  def build_started_game(attrs \\ []) do
    player_1 = Keyword.get(attrs, :player_1, build_player())
    player_2 = Keyword.get(attrs, :player_2, build_player())

    %Game{
      name: Keyword.get(attrs, :name, build_random_string()),
      board_info: Keyword.get(attrs, :board_info, build_board_info()),
      player_1: player_1,
      player_2: player_2,
      status: :started,
      turn: Keyword.get(attrs, :turn, Enum.random([player_1, player_2]))
    }
  end
end
