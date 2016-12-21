defmodule DexyLib.MappyTest do

  use ExUnit.Case
  use DexyLib
  alias DexyLib.Mappy

  doctest DexyLib.Mappy

  test "the true" do
    map = Mappy.set %{}, "a", 1
    assert 1 == Mappy.val map, "a" 

    map = Mappy.set %{}, "a.b", 1
    assert %{"b" => 1} == Mappy.val map, "a" 
    assert 1 == Mappy.val map, "a.b"
    assert nil == Mappy.val map, "a.bad"

    map = Mappy.new
    map = Mappy.set map, "b", "b" 
    map = Mappy.set map, "a.b", 1
    mykey = "a.b"
    assert 1 == Mappy.get map, mykey
    assert 1 == Mappy.get map, "a['b']"
    assert 1 == Mappy.get map, "a[b]"
    assert nil == Mappy.get map, "a[x]"
  end 

end
