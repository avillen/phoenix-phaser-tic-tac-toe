defmodule Hyta.Support.Core.Player do
  @moduledoc """
  Support module to build Player related data
  """

  alias Hyta.Core.Player

  import Hyta.Support.Shared, only: [build_random_string: 0]

  def build_player(attrs \\ []) do
    %Player{
      nick: Keyword.get(attrs, :nick, build_random_string())
    }
  end
end
