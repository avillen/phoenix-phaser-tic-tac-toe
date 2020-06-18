defmodule HytaWeb.GameChannel do
  @moduledoc """
  Game Channel management
  """

  use Phoenix.Channel

  alias Hyta.Core.Player

  alias __MODULE__.Serializer

  require Logger

  def join("game:" <> _game_name, _payload, socket) do
    {:ok, socket}
  end

  def handle_in("create", %{"username" => username, "game_name" => game_name}, socket) do
    player = Player.new(%{nick: username})

    case Hyta.create_game(game_name, player) do
      {:ok, game} ->
        broadcast!(socket, "create", Serializer.show(game))
        {:noreply, socket}

      {:error, reason} ->
        Logger.error("Error creating game: #{reason}")
        {:reply, {:error, Serializer.error(reason)}, socket}
    end
  end

  def handle_in("join", %{"username" => username, "game_name" => game_name}, socket) do
    player = Player.new(%{nick: username})

    case Hyta.join_game(game_name, player) do
      {:ok, game} ->
        broadcast!(socket, "join", Serializer.show(game))
        {:noreply, socket}

      {:error, reason} ->
        Logger.error("Error joining game: #{reason}")
        {:reply, {:error, Serializer.error(reason)}, socket}
    end
  end

  def handle_in(
        "move",
        %{"username" => username, "game_name" => game_name, "index" => index},
        socket
      ) do
    player = Player.new(%{nick: username})

    game = Hyta.get_game(game_name)
    {x, y} = build_coordinates(index, game.board_info.ancho)

    case Hyta.move(game_name, player, x, y) do
      {:ok, game} ->
        broadcast!(socket, "move", Serializer.show(game))
        {:noreply, socket}

      {:winner, game} ->
        Logger.warn("Winner #{inspect(game)}")
        broadcast!(socket, "move", Serializer.show(game))
        {:stop, :shutdown, socket}

      {:empate, game} ->
        Logger.warn("Empate #{inspect(game)}")
        broadcast!(socket, "move", Serializer.show(game))
        {:stop, :shutdown, socket}

      {:error, reason} ->
        Logger.error("Error moving in game: #{inspect(game)} -> #{inspect(reason)}")
        {:reply, {:error, Serializer.error(reason)}, socket}
    end
  end

  defp build_coordinates(index, ancho) do
    x = div(index, ancho)
    y = rem(index, ancho)

    {x, y}
  end
end
