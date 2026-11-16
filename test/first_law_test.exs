defmodule FirstLawTest do
  use ExUnit.Case
  doctest FirstLaw

  test "greets the world" do
    assert FirstLaw.hello() == :world
  end
end
