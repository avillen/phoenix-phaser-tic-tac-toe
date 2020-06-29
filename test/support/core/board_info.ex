defmodule Hyta.Support.Core.BoardInfo do
  @moduledoc """
  Support module to build Player related data
  """

  alias Hyta.Core.BoardInfo

  import Hyta.Support.Shared, only: [build_random_integer: 1]

  def build_board_info(attrs \\ []) do
    ancho = Keyword.get(attrs, :ancho, build_random_integer(min: 3))

    %BoardInfo{
      ancho: ancho,
      board: Keyword.get(attrs, :board, build_board(ancho))
    }
  end

  def build_board(ancho \\ 3) do
    for x <- 0..(ancho - 1), y <- 0..(ancho - 1), into: %{} do
      position = {x, y}
      value = nil

      {position, value}
    end
  end
end
