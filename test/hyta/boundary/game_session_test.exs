defmodule Hyta.Boundary.GameSessionTest do
  use ExUnit.Case, async: true

  alias Hyta.Boundary.GameSession

  import Hyta.Support.Core.Player, only: [build_player: 0]
  import Hyta.Support.Core.Game, only: [build_game: 0]

  import Hyta.Support.Boundary.GameSession,
    only: [
      create_game: 0,
      create_new_game: 0,
      create_ready_game: 0,
      create_started_game: 0
    ]

  test "start_link/1" do
    assert {:ok, pid} = GameSession.start_link(__MODULE__)
    assert Process.alive?(pid)
  end

  describe "build_game/2" do
    test "on success" do
      {:ok, pid} = GameSession.start_link(__MODULE__)

      game_name = "#{__MODULE__}-game_name"
      player_1 = build_player()

      assert {:ok, _} = GameSession.build_game(pid, game_name, player_1, 3)
    end
  end

  describe "join_game/2" do
    test "on success" do
      {:ok, pid, _game_session} = create_new_game()
      player_2 = build_player()

      assert {:ok, _game} = GameSession.join_game(pid, player_2)
    end

    test "error if the game is full of players" do
      {:ok, pid, _game_session} = create_new_game()
      player_2 = build_player()
      player_3 = build_player()

      {:ok, _game} = GameSession.join_game(pid, player_2)

      assert {:error, :full_game} = GameSession.join_game(pid, player_3)
    end

    test "error when the game not exists" do
      player_2 = build_player()
      assert {:error, :game_not_exists} == GameSession.join_game(:game_not_exists, player_2)
    end
  end

  describe "start_game/2" do
    test "on success" do
      {:ok, pid, _game_session} = create_ready_game()

      assert {:ok, _game} = GameSession.start_game(pid)
    end

    test "on error" do
      {:ok, pid, _game_session} = create_new_game()

      assert {:error, :missing_players} = GameSession.start_game(pid)
    end
  end

  describe "move/2" do
    test "on success" do
      {:ok, pid, %GameSession{session: game}} = create_started_game()

      assert {:ok, _game} = GameSession.move(pid, game.turn, 0, 0)
    end

    test "error" do
      player = build_player()
      {:ok, pid, _game_session} = create_started_game()

      assert {:error, :not_your_turn} == GameSession.move(pid, player, 0, 0)
    end
  end

  describe "get_session/1" do
    test "on success" do
      {:ok, pid, %GameSession{session: game}} = create_game()

      assert game == GameSession.get_session(pid)
    end
  end

  describe "backdoor_set_game/2" do
    test "on success" do
      {:ok, pid} = GameSession.start_link(__MODULE__)

      game = build_game()

      assert %GameSession{session: game} == GameSession.backdoor_set_game(pid, game)
    end
  end
end
