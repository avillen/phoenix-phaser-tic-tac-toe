defmodule Hyta.Core.BoardInfo do
  @moduledoc """
  BoardInfo struct and logic
  """

  alias __MODULE__

  @type t :: %BoardInfo{
          board: map(),
          ancho: non_neg_integer()
        }

  defstruct ~w(board ancho)a

  @type ancho :: non_neg_integer()

  @spec new(ancho) :: BoardInfo.t()
  def new(ancho) do
    %BoardInfo{
      board: build_board(ancho),
      ancho: ancho
    }
  end

  @type position :: non_neg_integer()
  @type value :: any()

  @spec set(BoardInfo.t(), position, position, value) ::
          {:ok, BoardInfo.t()}
          | {:error, :position_taken}
          | {:error, :out_of_index}
  def set(%BoardInfo{board: board} = state, x, y, value) do
    case Map.fetch(board, {x, y}) do
      {:ok, nil} -> {:ok, %{state | board: put_in_board(board, x, y, value)}}
      {:ok, _} -> {:error, :position_taken}
      :error -> {:error, :out_of_index}
    end
  end

  @spec full?(BoardInfo.t()) :: boolean()
  def full?(%BoardInfo{board: board}) do
    res =
      board
      |> Map.values()
      |> Enum.any?(&is_nil/1)

    !res
  end

  @spec line_full?(BoardInfo.t(), any()) :: boolean()
  def line_full?(%BoardInfo{board: board, ancho: ancho}, value) do
    row_full?(board, ancho, value) ||
      column_full?(board, ancho, value) ||
      diagonal_full?(board, ancho, value)
  end

  defp build_board(ancho) do
    for x <- 0..(ancho - 1), y <- 0..(ancho - 1), into: %{} do
      position = {x, y}
      value = nil

      {position, value}
    end
  end

  defp put_in_board(board, x, y, value), do: Map.put(board, {x, y}, value)

  defp row_full?(board, ancho, value) do
    board
    |> Map.values()
    |> Enum.chunk_every(ancho)
    |> Enum.map(&Enum.all?(&1, fn x -> x == value end))
    |> Enum.any?(fn x -> x == true end)
  end

  defp column_full?(board, ancho, value) do
    matrix =
      board
      |> Map.values()
      |> Enum.chunk_every(ancho)

    transposed = for t <- Enum.zip(matrix), do: Tuple.to_list(t)

    transposed
    |> Enum.map(&Enum.all?(&1, fn x -> x == value end))
    |> Enum.any?(fn x -> x == true end)
  end

  defp diagonal_full?(board, ancho, value) do
    diagonal_1 =
      board
      |> Map.values()
      |> Enum.chunk_every(ancho)
      |> check_diagonal(value)

    diagonal_2 =
      board
      |> Map.values()
      |> Enum.chunk_every(ancho)
      |> Enum.reverse()
      |> check_diagonal(value)

    diagonal_1 || diagonal_2
  end

  defp check_diagonal(board_lists, value) do
    board_lists
    |> Enum.with_index()
    |> Enum.map(fn {row, index} -> Enum.at(row, index) end)
    |> Enum.all?(fn x -> x == value end)
  end
end
