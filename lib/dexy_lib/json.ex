defmodule DexyLib.JSON do

  @adapter Application.get_env(:dexy_lib, __MODULE__)[:adapter]
    || __MODULE__.Adapters.Poison

  defmodule Adapter do
    @type json :: bitstring
    @type index :: non_neg_integer

    @callback encode(any) :: {:ok, bitstring} | {:error, term}
    @callback decode(json) :: {:ok, term} | {:error, {bitstring, index}}
  end

  defdelegate encode(any), to: @adapter
  defdelegate decode(json), to: @adapter

  def encode! any do
    case __MODULE__.encode any do
      {:ok, val} -> val
      {:error, reason} -> throw {:error, reason}
    end
  end

  def decode! any do
    case __MODULE__.decode any do
      {:ok, val} -> val
      {:error, {what, idx}} -> throw {:error, "'#{what}' at #{idx}"}
      {:error, reason} -> throw {:error, reason}
    end
  end

end
