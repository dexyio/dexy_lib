defmodule DexyLib.JSON.Adapters.Poison do
  
  @behaviour DexyLib.JSON.Adapter

  def encode(data) do
    case Poison.encode data do
      ok = {:ok, _} -> ok
      {:error, {:invalid, what}} -> {:error, what}
    end
  end
  
  def decode(json) do
    case Poison.decode json do
      ok = {:ok, _} -> ok
      {:error, {:invalid, what, idx}} -> {:error, {what, idx}}
    end
  end

end
