defmodule HytaTest do
  use ExUnit.Case

  import Hyta.Support.Core.Player, only: [build_player: 0]
  import Hyta.Support.Core.Game, only: [build_new_game: 0]

  @name __MODULE__

  describe "create_game" do
    test "success" do
      game = build_new_game()

      assert {:ok, game} == Hyta.create_game(game.name, game.player_1, game.board_info.ancho)
      assert [{_, nil}] = Registry.lookup(Hyta.Registry, game.name)
    end

    test "game already_started" do
      game_name = "#{@name}-create_game-already_started-game_name"
      player = build_player()

      assert {:ok, _response} = Hyta.create_game(game_name, player)
      assert {:error, :already_started} == Hyta.create_game(game_name, player)
    end
  end

  describe "move" do
    test "empate" do
      game_name = "#{@name}-move-success-empate-game_name"
      player_1 = build_player()
      player_2 = build_player()

      {:ok, _game} = Hyta.create_game(game_name, player_1, 3)

      assert {:ok, game} = Hyta.join_game(game_name, player_2)

      {:ok, game} = Hyta.move(game_name, game.turn, 0, 0)
      {:ok, game} = Hyta.move(game_name, game.turn, 0, 1)
      {:ok, game} = Hyta.move(game_name, game.turn, 0, 2)
      {:ok, game} = Hyta.move(game_name, game.turn, 1, 2)
      {:ok, game} = Hyta.move(game_name, game.turn, 1, 0)
      {:ok, game} = Hyta.move(game_name, game.turn, 2, 0)
      {:ok, game} = Hyta.move(game_name, game.turn, 1, 1)
      {:ok, game} = Hyta.move(game_name, game.turn, 2, 2)

      assert {:empate, _} = Hyta.move(game_name, game.turn, 2, 1)
      assert [] == Registry.lookup(Hyta.Registry, game.name)
    end
  end

  describe "get_game" do
    test "success" do
      game_name = "#{@name}-get_game-success-game_name"
      player = build_player()

      {:ok, game} = Hyta.create_game(game_name, player, 3)

      assert game == Hyta.get_game(game_name)
    end
  end
end
