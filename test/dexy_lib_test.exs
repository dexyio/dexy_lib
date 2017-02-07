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
  end

  test "raise error" do
    assert_raise Error.Foo, fn ->
      raise Error.Foo
    end
  end

end
