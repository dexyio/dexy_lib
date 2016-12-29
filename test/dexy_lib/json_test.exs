defmodule DexyLib.JSONTest do

  use ExUnit.Case
  use DexyLib
  alias DexyLib.JSON
  doctest DexyLib.JSON

  test "the true" do
    assert "null" == JSON.encode! nil
    assert "true" == JSON.encode! true
    assert "false" == JSON.encode! false
    assert "1" == JSON.encode! 1
    assert "[]" == JSON.encode! []
    assert "[1,2,3]" == JSON.encode! [1, 2, 3]
    assert "{}" == JSON.encode! %{}
    assert "{\"b\":2,\"a\":1}" == JSON.encode! %{:a => 1, "b" => 2}
  end

  test "incorrect" do
    assert {:error, {}} = catch_throw(JSON.encode! {}) 
    assert {:error, "'t' at 0"} = catch_throw(JSON.decode! "test") 
  end

end
