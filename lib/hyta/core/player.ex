defmodule Hyta.Core.Player do
  @moduledoc """
  Player struct and logic
  """

  alias __MODULE__

  @type t :: %Player{
          nick: String.t()
        }

  defstruct ~w(
    nick
  )a

  @spec new(map()) :: Player.t()
  def new(fields) do
    struct!(Player, fields)
  end
end
