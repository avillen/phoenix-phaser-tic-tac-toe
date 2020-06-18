defmodule Hyta.Core.GameTest do
  use ExUnit.Case, async: true

  alias Hyta.Core.{
    BoardInfo,
    Game,
    Player
  }

  test "new/1" do
    player = Player.new(%{nick: "Yago"})
    board_info = BoardInfo.new(3)
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
      player_1 = Player.new(%{nick: "Yago"})
      player_2 = Player.new(%{nick: "Hugo"})
      game_name = "#{__MODULE__}-game_name"
      board_info = BoardInfo.new(3)

      game = Game.new(game_name, player_1, board_info)

      {:ok, game} = Game.join(game, player_2)

      assert %Game{
               name: game.name,
               board_info: board_info,
               player_1: player_1,
               player_2: player_2,
               status: :ready,
               turn: nil
             } == game
    end

    test "you can't join to the game because there is another player" do
      player_1 = Player.new(%{nick: "Yago"})
      player_2 = Player.new(%{nick: "Hugo"})
      player_3 = Player.new(%{nick: "Alvaro"})
      game_name = "#{__MODULE__}-game_name"
      board_info = BoardInfo.new(3)

      game = Game.new(game_name, player_1, board_info)
      {:ok, game} = Game.join(game, player_2)

      assert {:error, :full_game} == Game.join(game, player_3)
    end
  end

  describe "start/1" do
    test "the game starts" do
      player_1 = Player.new(%{nick: "Yago"})
      player_2 = Player.new(%{nick: "Hugo"})
      game_name = "#{__MODULE__}-game_name"
      board_info = BoardInfo.new(3)
      game = Game.new(game_name, player_1, board_info)

      {:ok, game} = Game.join(game, player_2)
      {:ok, game} = Game.start(game)

      assert %Game{
               name: game.name,
               board_info: board_info,
               player_1: player_1,
               player_2: player_2,
               status: :started,
               turn: game.turn
             } == game
    end

    test "can't start because there is a missing player" do
      player_1 = Player.new(%{nick: "Yago"})
      game_name = "#{__MODULE__}-game_name"
      board_info = BoardInfo.new(3)

      game = Game.new(game_name, player_1, board_info)

      {:error, :missing_players} = Game.start(game)
    end
  end

  describe "move/3" do
    setup do
      player_1 = Player.new(%{nick: "Yago"})
      player_2 = Player.new(%{nick: "Hugo"})
      game_name = "#{__MODULE__}-game_name"
      board_info = BoardInfo.new(3)
      game = Game.new(game_name, player_1, board_info)

      {:ok, game} = Game.join(game, player_2)
      {:ok, game} = Game.start(game)

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
      {:ok, game} = Game.move(game, game.turn, 1, 0)
      {:ok, game} = Game.move(game, game.turn, 1, 1)
      {:ok, game} = Game.move(game, game.turn, 1, 2)
      {:ok, game} = Game.move(game, game.turn, 2, 0)
      {:ok, game} = Game.move(game, game.turn, 2, 1)

      assert {:empate, _} = Game.move(game, game.turn, 2, 2)
    end
  end
end
