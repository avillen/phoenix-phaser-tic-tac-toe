defmodule Hyta.Core.PlayerTest do
  use ExUnit.Case, async: true

  alias Hyta.Core.Player

  test "new/1" do
    attrs = %{
      nick: "Yago"
    }

    assert %Player{nick: attrs.nick} == Player.new(attrs)
  end
end
