defmodule DexyLib.JSON.Adapters.Poison do
  
  @behaviour DexyLib.JSON.Adapter

  def decode!(json) do
    Poison.decode! json
  end

  def encode!(data, _options \\ []) do
    Poison.encode! data
  end
  
end
