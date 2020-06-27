defmodule Hyta.Support.Boundary.GameSession do
  @moduledoc """
  Support module to build GameSession related data
  """

  alias Hyta.Boundary.GameSession

  import Hyta.Support.Shared, only: [build_random_string: 0]

  import Hyta.Support.Core.Game,
    only: [
      build_game: 1,
      build_new_game: 1,
      build_ready_game: 1,
      build_started_game: 1
    ]

  def create_game(attrs \\ []) do
    {:ok, pid} = GameSession.start_link(build_random_string())

    game = build_game(attrs)
    game_session = GameSession.backdoor_set_game(pid, game)
    {:ok, pid, game_session}
  end

  def create_new_game(attrs \\ []) do
    {:ok, pid} = GameSession.start_link(build_random_string())

    game = build_new_game(attrs)
    game_session = GameSession.backdoor_set_game(pid, game)
    {:ok, pid, game_session}
  end

  def create_ready_game(attrs \\ []) do
    {:ok, pid} = GameSession.start_link(build_random_string())

    game = build_ready_game(attrs)
    game_session = GameSession.backdoor_set_game(pid, game)
    {:ok, pid, game_session}
  end

  def create_started_game(attrs \\ []) do
    {:ok, pid} = GameSession.start_link(build_random_string())

    game = build_started_game(attrs)
    game_session = GameSession.backdoor_set_game(pid, game)
    {:ok, pid, game_session}
  end
end
