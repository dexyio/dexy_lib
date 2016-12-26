defmodule DexyLib.Error do

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
    end
  end # defmacro

  defmacro deferror name, code \\ nil do
    quote do
      defmodule unquote(name) do
        defexception message: to_string(unquote name)
                              |> String.split(".") |> List.last,
                     code: unquote(code),
                     reason: nil,
                     state: nil
      end
    end
  end

end
