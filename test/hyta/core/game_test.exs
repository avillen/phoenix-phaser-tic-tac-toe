defmodule Hyta.Core.GameTest do
  use ExUnit.Case, async: true

  import Hyta.Support.Core.Player,
    only: [
      build_player: 0
    ]

  import Hyta.Support.Core.BoardInfo,
    only: [
      build_board_info: 0,
      build_board_info: 1
    ]

  import Hyta.Support.Core.Game,
    only: [
      build_new_game: 0,
      build_ready_game: 0,
      build_started_game: 1
    ]

  alias Hyta.Core.Game

  test "new/1" do
    player = build_player()
    board_info = build_board_info()
    game_name = "#{__MODULE__}-game_name"

    game = Game.new(game_name, player, board_info)

    assert %Game{
             name: game.name,
             board_info: board_info,
             player_1: player,
             player_2: nil,
             status: :waiting_for_player,
             turn: nil
           } == game
  end

  describe "join/2" do
    test "you can join to the game" do
      player_2 = build_player()
      game = build_new_game()

      response = %Game{
        name: game.name,
        board_info: game.board_info,
        player_1: game.player_1,
        player_2: player_2,
        status: :ready,
        turn: nil
      }

      assert {:ok, response} == Game.join(game, player_2)
    end

    test "you can't join to the game because there is another player and the game is ready" do
      player_3 = build_player()
      game = build_ready_game()

      assert {:error, :full_game} == Game.join(game, player_3)
    end
  end

  describe "start/1" do
    test "the game starts" do
      player = build_player()
      game = build_started_game(player_1: player, turn: player)

      response = %Game{
        name: game.name,
        board_info: game.board_info,
        player_1: player,
        player_2: game.player_2,
        status: :started,
        turn: game.turn
      }

      assert {:ok, response} == Game.start(game, fn _ -> player end)
    end

    test "can't start because there is a missing player" do
      game = build_new_game()

      {:error, :missing_players} = Game.start(game)
    end
  end

  describe "move/3" do
    setup do
      board_info = build_board_info(ancho: 3)
      game = build_started_game(board_info: board_info)

      %{game: game}
    end

    test "error if is not your turn", %{game: game} do
      current_player = game.turn
      {:ok, game} = Game.move(game, current_player, 0, 0)

      assert {:error, :not_your_turn} == Game.move(game, current_player, 0, 1)
    end

    test "winner", %{game: game} do
      {:ok, game} = Game.move(game, game.turn, 0, 0)
      {:ok, game} = Game.move(game, game.turn, 1, 0)
      {:ok, game} = Game.move(game, game.turn, 0, 1)
      {:ok, game} = Game.move(game, game.turn, 1, 1)

      assert {:winner, _} = Game.move(game, game.turn, 0, 2)
    end

    test "empate", %{game: game} do
      {:ok, game} = Game.move(game, game.turn, 0, 0)
      {:ok, game} = Game.move(game, game.turn, 0, 1)
      {:ok, game} = Game.move(game, game.turn, 0, 2)
      {:ok, game} = Game.move(game, game.turn, 1, 2)
      {:ok, game} = Game.move(game, game.turn, 1, 0)
      {:ok, game} = Game.move(game, game.turn, 2, 0)
      {:ok, game} = Game.move(game, game.turn, 1, 1)
      {:ok, game} = Game.move(game, game.turn, 2, 2)

      assert {:empate, _} = Game.move(game, game.turn, 2, 1)
    end
  end
end
