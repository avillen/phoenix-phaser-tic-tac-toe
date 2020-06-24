defmodule HytaWeb.GameChannel.Serializer do
  @moduledoc """
  Builds Game responses
  """

  require Logger

  def show(game) do
    res = %{
      response: %{
        name: game.name,
        board_info: %{
          ancho: game.board_info.ancho,
          board: build_board(game.board_info.board)
        },
        player_1: build_player(game.player_1),
        player_2: build_player(game.player_2),
        status: Atom.to_string(game.status),
        turn: build_player(game.turn)
      }
    }

    Logger.info(inspect({__MODULE__, :show, res}))

    res
  end

  def error(reason) do
    %{
      response: reason
    }
  end

  defp build_board(board), do: Map.values(board)

  defp build_player(nil), do: nil
  defp build_player(player), do: Map.from_struct(player)
end
