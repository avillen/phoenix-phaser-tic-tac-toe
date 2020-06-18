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
      user_name = "#{@name}-handle_in-create-user_name-success"
      user_socket = socket(UserSocket, nil, %{})

      assert {:ok, _, socket} = subscribe_and_join(user_socket, "game:#{game_name}")

      _ref = push(socket, "create", %{"username" => user_name, "game_name" => game_name})

      assert_broadcast "create", %{response: _}
    end
  end

  describe "handle_in join" do
    test "joins a game" do
      game_name = "#{@name}-handle_in-join-game_name-success"
      user_name_1 = "#{@name}-handle_in-join-user_name_1-success"
      user_name_2 = "#{@name}-handle_in-join-user_name_2-success"
      user_socket = socket(UserSocket, nil, %{})

      assert {:ok, _, socket} = subscribe_and_join(user_socket, "game:#{game_name}")

      _ = push(socket, "create", %{"username" => user_name_1, "game_name" => game_name})
      _ = push(socket, "join", %{"username" => user_name_2, "game_name" => game_name})

      assert_broadcast "join", %{response: _}
    end
  end

  describe "handle_in move" do
    test "joins a game" do
      game_name = "#{@name}-handle_in-move-game_name-success"
      user_name_1 = "#{@name}-handle_in-move-user_name_1-success"
      user_name_2 = "#{@name}-handle_in-move-user_name_2-success"
      user_socket = socket(UserSocket, nil, %{})

      assert {:ok, _, socket} = subscribe_and_join(user_socket, "game:#{game_name}")

      _ = push(socket, "create", %{"username" => user_name_1, "game_name" => game_name})
      _ = push(socket, "join", %{"username" => user_name_2, "game_name" => game_name})

      _ =
        push(socket, "move", %{"username" => user_name_2, "game_name" => game_name, "index" => 3})

      assert_broadcast "move", %{response: _}
    end
  end
end
