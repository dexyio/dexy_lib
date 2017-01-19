defmodule DexyLib.MappyTest do

  use ExUnit.Case
  use DexyLib
  alias DexyLib.Mappy

  doctest DexyLib.Mappy

  test "set & get" do
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
    assert nil == Mappy.get map, "a[,x]"
    assert nil == Mappy.get %{}, "invalid"
  end 

  test "foo" do
    map = Mappy.set %{}, "data", [1, 2, 3]
    map = Mappy.set map, "i", 1
    map = Mappy.set map, "data[i]", 4
    IO.inspect map
  end

end
