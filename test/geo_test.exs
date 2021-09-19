defmodule JofferTest do
  use ExUnit.Case
  doctest Joffer

  test "greets the world" do
    assert Joffer.hello() == :world
  end
end
