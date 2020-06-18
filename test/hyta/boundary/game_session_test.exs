defmodule Hyta.Boundary.GameSessionTest do
  use ExUnit.Case, async: true

  alias Hyta.Boundary.GameSession
  alias Hyta.Core.Player

  setup do
    {:ok, pid} = GameSession.start_link(__MODULE__)

    {:ok, %{pid: pid}}
  end

  test "build_game/2", %{pid: pid} do
    player_1 = Player.new(%{nick: "Hugo"})
    game_name = "#{__MODULE__}-game_name"

    assert {:ok, _} = GameSession.build_game(pid, game_name, player_1, 3)

    player_2 = Player.new(%{nick: "Yago"})
    assert {:ok, _} = GameSession.join_game(pid, player_2)
    assert {:ok, _} = GameSession.start_game(pid)

    # assert {:ok, _} = GameSession.move(pid, player_1, 0, 0)
  end

  test "get_session/1", %{pid: pid} do
    player_1 = Player.new(%{nick: "Yago"})
    game_name = "#{__MODULE__}-get_session-game_name"

    {:ok, game} = GameSession.build_game(pid, game_name, player_1, 3)

    assert game == GameSession.get_session(pid)
  end
end
