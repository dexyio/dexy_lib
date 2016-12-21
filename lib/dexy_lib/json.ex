defmodule DexyLib.JSON do

  @adapter Application.get_env(:dexy_lib, __MODULE__)[:adapter]
    || __MODULE__.Adapters.Poison

  defmodule Adapter do
    @type json :: bitstring

    @callback decode!(json) :: term
    @callback encode!(any) :: bitstring
  end

  defdelegate decode!(json), to: @adapter
  defdelegate encode!(any), to: @adapter

end
