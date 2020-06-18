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

  describe "get_game" do
    test "success" do
      game_name = "#{@name}-get_game-success-game_name"
      player = %Player{nick: "Yago"}

      {:ok, game} = Hyta.create_game(game_name, player)

      assert game == Hyta.get_game(game_name)
    end
  end
end
