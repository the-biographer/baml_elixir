defmodule BamlElixirTest do
  use ExUnit.Case
  doctest BamlElixir

  test "greets the world" do
    assert BamlElixir.hello() == :world
  end
end
