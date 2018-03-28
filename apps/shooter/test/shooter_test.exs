defmodule ShooterTest do
  use ExUnit.Case
  doctest Shooter

  test "greets the world" do
    assert Shooter.hello() == :world
  end
end
