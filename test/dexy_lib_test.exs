defmodule DexyLibTest do

  use ExUnit.Case
  use DexyLib
  doctest DexyLib

  deferror Error.Foo
  deferror Error.Bar

  test "the true" do
    assert 2 == 1 + 1
  end 

  test "raise error" do
    assert_raise Error.Foo, fn ->
      raise Error.Foo
    end
  end

end
