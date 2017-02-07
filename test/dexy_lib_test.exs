defmodule DexyLibTest do

  use ExUnit.Case
  use DexyLib, as: Lib
  doctest DexyLib

  deferror Error.Foo
  deferror Error.Bar

  test "supervisor" do
    defmodule Supervisor do
      use Lib.Supervisor, otp_app: :dexy_lib
    end

    defmodule Foo.Supervisor do
      use Lib.Supervisor, otp_app: :dexy_lib
    end

    defmodule Foo.Worker do
      use GenServer
      def start_link, do: GenServer.start_link(__MODULE__, [])
      def init(state), do: {:ok, state}
    end

    Application.put_env(:dexy_lib, __MODULE__.Supervisor, children: [
      supervisor: Foo.Supervisor,
      worker: Foo.Worker
    ])

    {:ok, _pid} = Supervisor.start_link
    assert [{Foo.Worker, _}, {Foo.Supervisor, _}] = Supervisor.members
  end 

  test "public functions" do
    assert String.length(Lib.unique) == 19
    assert Lib.to_string(nil) == ""
    assert Lib.to_string(nil, "nil") == "nil"
    assert Lib.to_string(:atom) == "atom"
    assert Lib.to_string(123) == "123"
    assert Lib.to_string("foo") == "foo"
    assert Lib.to_string([]) == "[]"
    assert Lib.to_string(Map.new) == "%{}"
  end

  test "raise error" do
    assert_raise Error.Foo, fn ->
      raise Error.Foo
    end
  end

end
