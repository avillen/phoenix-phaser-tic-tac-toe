defmodule Hyta.Core.BoardInfoTest do
  use ExUnit.Case, async: true
  alias Hyta.Core.BoardInfo

  test "new/2" do
    board = %{
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

    assert %BoardInfo{board: board, ancho: 3} == BoardInfo.new(3)
  end

  describe "set/4" do
    test "sets a cell of the board" do
      board = BoardInfo.new(2)

      board_response = %{
        {0, 0} => nil,
        {0, 1} => nil,
        {1, 0} => nil,
        {1, 1} => "x"
      }

      assert {:ok, %BoardInfo{board: board_response, ancho: 2}} == BoardInfo.set(board, 1, 1, "x")
    end

    test "error when you try to set a taken cell" do
      board = BoardInfo.new(3)

      {:ok, board} = BoardInfo.set(board, 1, 1, "x")

      assert {:error, :position_taken} == BoardInfo.set(board, 1, 1, "x")
    end

    test "error when you try to set a cell that not exists" do
      board = BoardInfo.new(3)

      assert {:error, :out_of_index} == BoardInfo.set(board, 4, 4, "x")
    end
  end

  describe "full?/1" do
    test "if is full returns true" do
      board = BoardInfo.new(2)

      {:ok, board} = BoardInfo.set(board, 0, 0, "x")
      {:ok, board} = BoardInfo.set(board, 0, 1, "x")
      {:ok, board} = BoardInfo.set(board, 1, 0, "x")
      {:ok, board} = BoardInfo.set(board, 1, 1, "x")

      assert true == BoardInfo.full?(board)
    end

    test "if is not full returns false" do
      board = BoardInfo.new(2)

      assert false == BoardInfo.full?(board)
    end
  end

  describe "line_full?/1" do
    test "full row returns true" do
      board = BoardInfo.new(3)

      {:ok, board} = BoardInfo.set(board, 0, 0, "x")
      {:ok, board} = BoardInfo.set(board, 0, 1, "x")
      {:ok, board} = BoardInfo.set(board, 0, 2, "x")

      assert true == BoardInfo.line_full?(board, "x")
    end

    test "full column returns true" do
      board = BoardInfo.new(3)

      {:ok, board} = BoardInfo.set(board, 0, 0, "x")
      {:ok, board} = BoardInfo.set(board, 1, 0, "x")
      {:ok, board} = BoardInfo.set(board, 2, 0, "x")

      assert true == BoardInfo.line_full?(board, "x")
    end

    # test "full diagonal returns true" do
    #   board = BoardInfo.new(3)

    #   {:ok, board} = BoardInfo.set(board, 0, 0, "x")
    #   {:ok, board} = BoardInfo.set(board, 1, 1, "x")
    #   {:ok, board} = BoardInfo.set(board, 2, 2, "x")

    #   assert true == BoardInfo.line_full?(board, "x")
    # end

    test "if is not full returns false" do
      board = BoardInfo.new(2)

      assert false == BoardInfo.line_full?(board, "o")
    end
  end
end
