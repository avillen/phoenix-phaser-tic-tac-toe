defmodule HytaTest do
  use ExUnit.Case

  alias Hyta.Core.{
    BoardInfo,
    Game,
    Player
  }

  @name __MODULE__

  describe "create_game" do
    test "success" do
      game_name = "#{@name}-create_game-success-game_name"
      player = %Player{nick: "Yago"}

      response = %Game{
        board_info: %BoardInfo{
          ancho: 3,
          board: %{
            {0, 0} => nil,
            {0, 1} => nil,
            {0, 2} => nil,
            {1, 0} => nil,
            {1, 1} => nil,
            {1, 2} => nil,
            {2, 0} => nil,
            {2, 1} => nil,
            {2, 2} => nil
          }
        },
        name: game_name,
        player_1: player,
        player_2: nil,
        status: :waiting_for_player,
        turn: nil
      }

      assert {:ok, response} == Hyta.create_game(game_name, player)
    end

    test "game already_started" do
      game_name = "#{@name}-create_game-already_started-game_name"
      player = %Player{nick: "Hugo"}

      assert {:ok, _response} = Hyta.create_game(game_name, player)
      assert {:error, :already_started} == Hyta.create_game(game_name, player)
    end
  end

  describe "move" do
    test "empate" do
      game_name = "#{@name}-move-success-empate-game_name"
      player_1 = %Player{nick: "Yago"}
      player_2 = %Player{nick: "Hugo"}

      {:ok, _game} = Hyta.create_game(game_name, player_1)
      {:ok, game} = Hyta.join_game(game_name, player_2)

      {:ok, game} = Hyta.move(game_name, game.turn, 0, 0)
      {:ok, game} = Hyta.move(game_name, game.turn, 0, 1)
      {:ok, game} = Hyta.move(game_name, game.turn, 0, 2)
      {:ok, game} = Hyta.move(game_name, game.turn, 1, 0)
      {:ok, game} = Hyta.move(game_name, game.turn, 1, 1)
      {:ok, game} = Hyta.move(game_name, game.turn, 1, 2)
      {:ok, game} = Hyta.move(game_name, game.turn, 2, 0)
      {:ok, game} = Hyta.move(game_name, game.turn, 2, 1)

      assert {:empate, _} = Hyta.move(game_name, game.turn, 2, 2)
    end
  end

  describe "get_game" do
    test "success" do
      game_name = "#{@name}-get_game-success-game_name"
      player = %Player{nick: "Yago"}

      {:ok, game} = Hyta.create_game(game_name, player)

      assert game == Hyta.get_game(game_name)
    end
  end
end
