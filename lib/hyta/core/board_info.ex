defmodule Hyta.Core.BoardInfo do
  @moduledoc """
  BoardInfo struct and logic
  """

  alias __MODULE__

  @type t :: %BoardInfo{
          board: map(),
          ancho: non_neg_integer()
        }

  defstruct board: %{}, ancho: 3

  @spec new(non_neg_integer()) :: BoardInfo.t()
  def new(ancho) do
    %BoardInfo{
      board: build_board(ancho),
      ancho: ancho
    }
  end

  @spec set(BoardInfo.t(), non_neg_integer(), non_neg_integer(), any()) ::
          {:ok, BoardInfo.t()} | {:error, :position_taken} | {:error, :out_of_index}
  def set(%BoardInfo{board: board} = state, x, y, value) do
    case Map.fetch(board, {x, y}) do
      {:ok, nil} ->
        {:ok, %{state | board: Map.put(board, {x, y}, value)}}

      {:ok, _} ->
        {:error, :position_taken}

      :error ->
        {:error, :out_of_index}
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

  defp diagonal_full?(_board, _ancho, _value) do
    false
  end

  defp build_board(ancho) do
    for x <- 0..(ancho - 1), y <- 0..(ancho - 1), into: %{} do
      position = {x, y}
      value = nil

      {position, value}
    end
  end
end
