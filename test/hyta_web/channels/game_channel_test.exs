defmodule HytaWeb.GameChannelTest do
  use HytaWeb.ChannelCase

  alias HytaWeb.UserSocket

  @name __MODULE__

  describe "join/3 success" do
    test "ok when there is a game name" do
      game_name = "#{@name}-join-game_name-success"
      user_socket = socket(UserSocket, nil, %{})

      assert {:ok, _, %Phoenix.Socket{}} = subscribe_and_join(user_socket, "game:#{game_name}")
    end
  end

  describe "handle_in create" do
    test "creates a game" do
      game_name = "#{@name}-handle_in-create-game_name-success"
      player_name = "#{@name}-handle_in-create-player_name-success"
      user_socket = socket(UserSocket, nil, %{})

      assert {:ok, _, socket} = subscribe_and_join(user_socket, "game:#{game_name}")

      _ref = push(socket, "create", %{"player_name" => player_name, "game_name" => game_name})

      assert_broadcast "create", %{response: _}
    end
  end

  describe "handle_in join" do
    test "joins a game" do
      game_name = "#{@name}-handle_in-join-game_name-success"
      player_name_1 = "#{@name}-handle_in-join-player_name_1-success"
      player_name_2 = "#{@name}-handle_in-join-player_name_2-success"
      user_socket = socket(UserSocket, nil, %{})

      assert {:ok, _, socket} = subscribe_and_join(user_socket, "game:#{game_name}")

      _ = push(socket, "create", %{"player_name" => player_name_1, "game_name" => game_name})
      _ = push(socket, "join", %{"player_name" => player_name_2, "game_name" => game_name})

      assert_broadcast "join", %{response: _}
    end
  end

  # describe "handle_in move" do
  #   test "joins a game" do
  #     game_name = "#{@name}-handle_in-move-game_name-success"
  #     player_name_1 = "#{@name}-handle_in-move-player_name_1-success"
  #     player_name_2 = "#{@name}-handle_in-move-player_name_2-success"
  #     user_socket = socket(UserSocket, nil, %{})

  #     assert {:ok, _, socket} = subscribe_and_join(user_socket, "game:#{game_name}")

  #     _ = push(socket, "create", %{"player_name" => player_name_1, "game_name" => game_name})
  #     _ = push(socket, "join", %{"player_name" => player_name_2, "game_name" => game_name})

  #     _ =
  #       push(socket, "move", %{
  #         "player_name" => player_name_2,
  #         "game_name" => game_name,
  #         "index" => 3
  #       })

  #     assert_broadcast "move", %{response: _}
  #   end
  # end
end
