defmodule Hyta.Support.Shared do
  @moduledoc """
  Support module to build shared data
  """

  def build_random_string(length \\ 10) do
    alphabet = Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9)

    Enum.take_random(alphabet, length)
  end

  def build_random_integer(range \\ []) do
    min = Keyword.get(range, :min, 1)
    max = Keyword.get(range, :max, 10)

    Enum.random(min..max)
  end
end
