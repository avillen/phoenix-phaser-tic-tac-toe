defmodule Hyta.Core.BoardInfoTest do
  use ExUnit.Case, async: true
  alias Hyta.Core.BoardInfo

  import Hyta.Support.Core.BoardInfo,
    only: [
      build_board: 1,
      build_board_info: 1
    ]

  test "new/2" do
    board = %{
      {0, 0} => nil,
      {0, 1} => nil,
      {1, 0} => nil,
      {1, 1} => nil
    }

    assert %BoardInfo{board: board, ancho: 2} == BoardInfo.new(2)
  end

  describe "set/4" do
    test "sets a cell of the board" do
      ancho = 2
      board_info = build_board_info(ancho: ancho)

      board_response = %{build_board(ancho) | {1, 1} => "x"}

      assert {:ok, %BoardInfo{board: board_response, ancho: ancho}} ==
               BoardInfo.set(board_info, 1, 1, "x")
    end

    test "error when you try to set a taken cell" do
      ancho = 2
      board = %{build_board(ancho) | {1, 1} => "x"}
      board_info = build_board_info(ancho: ancho, board: board)

      assert {:error, :position_taken} == BoardInfo.set(board_info, 1, 1, "x")
    end

    test "error when you try to set a cell that not exists" do
      ancho = 3
      board_info = build_board_info(ancho: ancho)

      assert {:error, :out_of_index} == BoardInfo.set(board_info, 4, 4, "x")
    end
  end

  describe "full?/1" do
    test "if is full returns true" do
      ancho = 2
      board = %{build_board(ancho) | {0, 0} => "x", {0, 1} => "x", {1, 0} => "x", {1, 1} => "x"}
      board_info = build_board_info(ancho: ancho, board: board)

      assert true == BoardInfo.full?(board_info)
    end

    test "if is not full returns false" do
      ancho = 2
      board_info = build_board_info(ancho: ancho)

      assert false == BoardInfo.full?(board_info)
    end
  end

  describe "line_full?/1" do
    test "full row returns true" do
      ancho = 3
      board = %{build_board(ancho) | {0, 0} => "x", {0, 1} => "x", {0, 2} => "x"}
      board_info = build_board_info(ancho: ancho, board: board)

      assert true == BoardInfo.line_full?(board_info, "x")
    end

    test "full column returns true" do
      ancho = 3
      board = %{build_board(ancho) | {0, 0} => "x", {1, 0} => "x", {2, 0} => "x"}
      board_info = build_board_info(ancho: ancho, board: board)

      assert true == BoardInfo.line_full?(board_info, "x")
    end

    test "full diagonal returns true" do
      ancho = 4
      board = %{build_board(ancho) | {0, 0} => "x", {1, 1} => "x", {2, 2} => "x", {3, 3} => "x"}
      board_info = build_board_info(ancho: ancho, board: board)

      assert true == BoardInfo.line_full?(board_info, "x")
    end

    test "other full diagonal returns true" do
      ancho = 3
      board = %{build_board(ancho) | {0, 2} => "x", {1, 1} => "x", {2, 0} => "x"}
      board_info = build_board_info(ancho: ancho, board: board)

      assert true == BoardInfo.line_full?(board_info, "x")
    end

    test "if is not full returns false" do
      ancho = 2
      board_info = build_board_info(ancho: ancho)

      assert false == BoardInfo.line_full?(board_info, "o")
    end
  end
end
