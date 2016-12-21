defmodule DexyLibTest do

  use ExUnit.Case
  use DexyLib
  doctest DexyLib

  deferror ErrorFoo
  deferror ErrorBar

  test "the true" do
    assert 2 == 1 + 1
  end 

  test "raise error" do
    assert_raise ErrorFoo, fn ->
      raise ErrorFoo
    end
  end

end
