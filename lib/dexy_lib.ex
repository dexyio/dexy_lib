defmodule DexyLib do

  defmacro __using__(opts \\ []) do
    quote_as = (as = opts[:as]) && quote do
      alias unquote(__MODULE__), as: unquote(as)
    end
    quote do
      unquote quote_as
      use unquote(__MODULE__).Error
      require unquote(__MODULE__).Mappy
    end
  end # defmacro

  def get(data, key, default \\ nil) do
    case do_get data, key do
      :error -> default
      val -> val
    end
  end

  defp do_get(data = _.._, key) do get_range data, key end
  defp do_get(data, key) when is_map(data) do get_map data, key end
  defp do_get(data, key) when is_list(data) do get_list data, key end
  defp do_get(data, key) when is_tuple(data) do get_tuple data, key end
  defp do_get(data, key) when is_bitstring(data) do get_string data, key end
  defp do_get(_data, _key) do :error end

  defp get_list(data, key = _.._), do: slice data, key
  defp get_list(data, key) when is_number(key), do: at data, key
  defp get_list(data, key) when is_list(key),
       do: for x <- key, do: get_list(data, x)
  defp get_list(_, _), do: :error

  defp get_range(data, key = _.._), do: slice data, key
  defp get_range(data, key) when is_number(key), do: at data, key
  defp get_range(data, key) when is_list(key),
       do: for x <- key, do: get_range(data, x)
  defp get_range(_, _), do: :error

  defp get_map(data, key = _.._), do: slice data, key
  defp get_map(data, key) when is_number(key), do: at data, key
  defp get_map(data, key) when is_bitstring(key), do: Map.get(data, key, :error)
  defp get_map(data, key) when is_list(key),
       do: for x <- key, into: %{}, do: get_map(data, x)
  defp get_map(data, key) when is_map(key),
       do: for {k, v} <- key, data[k] == v, into: %{}, do: {k, v}
  defp get_map(_, _), do: :error

  defp get_tuple(data, key = _.._), do: slice data, key
  defp get_tuple(data, key) when is_number(key), do: at data, key
  defp get_tuple(data, key) when is_list(key),
       do: for x <- key, into: {}, do: get_tuple(data, x)
  defp get_tuple(data, key) when is_tuple(key),
       do: for x <- Tuple.to_list(key), Enum.member?(data, x), into: {}, do: x
  defp get_tuple(_, _), do: :error

  defp get_string(data, key) do
    case String.codepoints(data) |> get_list(key) do
      res when is_list(res) -> Enum.join(res)
      res -> res
    end
  end

  def at(val, idx) when is_number(idx), do: do_at val, idx
  def at(_val, _idx), do: :error 

  def at!(val, idx), do: (res = at val, idx) == :error && nil || res

  defp do_at(val, idx) when is_list(val) or is_map(val) do
    Enum.at val, idx
  end
  
  defp do_at(val, idx) when is_bitstring(val) do
    String.at val, idx
  end

  defp do_at(val, idx) when is_tuple(val) do
    val |> Tuple.to_list |> do_at(idx)
  end

  defp do_at(val, idx) when is_number(val) do
    Range.new(0, val) |> do_at(idx)
  end

  defp do_at(val, _) do val end

  def length do 0 end
  def length(a..b) do a..b |> Enum.count end
  def length(val) when is_list(val) do Kernel.length val end
  def length(val) when is_map(val) do Map.size val end
  def length(val) when is_bitstring(val) do String.length val end
  def length(val) when is_tuple(val) do tuple_size val end
  def length(val) when is_number(val) do
    val |> to_string |> __MODULE__.length
  end

  def length nil do 0 end
  def length val do val end

  def lines str do do_lines str, [] end
  def lines str, opts do do_lines str, opts end

  defp do_lines str, opts do
    regex = opts[:trim] && ~r/ *\r*\n */ || ~r/\r*\n/
    String.split str, regex, opts
  end

  defmacro now, do: quote do: :os.timestamp

  defmacro now(:secs), do: quote do: Timex.Duration.now(:seconds)
  defmacro now(:msecs), do: quote do: Timex.Duration.now(:milliseconds)
  defmacro now(:usecs), do: quote do: Timex.Duration.now(:microseconds)

  defmacro datetime_now(timezone \\ "UTC") 
  defmacro datetime_now(timezone), do: quote do: Timex.now unquote(timezone)

  defmacro datetime_format! now, "iso" do
    quote do: Timex.format! unquote(now), "{ISO:Extended}"
  end

  defmacro datetime_format! now, "isoz" do
    quote do: Timex.format! unquote(now), "{ISO:Extended:Z}" # 2016-11-08T07:33:11.136Z
  end

  defmacro unique do
    quote do
      :base62.encode(<<trunc(unquote(__MODULE__).now :usecs)::64>>) <>
      :base62.encode(<<:erlang.phash2(node())::32, :crypto.strong_rand_bytes(4)::binary>>)
    end
  end

  def to_binary any do :erlang.term_to_binary any end

  def binary_to_term(bin) when is_binary(bin) do
    :erlang.binary_to_term bin
  end

  def binary_to_term not_bin do not_bin end

  def to_number(str), do: to_number(str, str)
  def to_number(str, default) when is_bitstring(str) do
    cond do
      str in [nil, ""] -> default
      true ->
        String.contains?(str, ".") \
          && String.to_float(str) \
          || String.to_integer(str)
    end
  end
  def to_number(str, _) when is_number(str), do: str
  def to_number(nil, _) do 0 end
  def to_number(_, default) do default end

  def trim(str) do String.trim str end
  def trim(str, to_trim) do String.trim str, to_trim end

  def ltrim(str) do String.trim_leading str end
  def ltrim(str, to_trim) do String.trim_leading str, to_trim end

  def rtrim(str) do String.trim_trailing str end
  def rtrim(str, to_trim) do String.trim_trailing str, to_trim end

  def count(val) when is_list(val) or is_map(val), do: Enum.count(val)
  def count(val) when is_tuple(val), do: val |> Tuple.to_list |> count
  def count(val) when is_bitstring(val), do: String.length(val)
  def count(val) when is_number(val), do: val
  def count(_), do: 0

  def slice(val, range = _.._), do: do_slice val, range 
  def slice(_val, _range), do: :error
  def slice!(val, range), do: (res = slice val, range) == :error && [] || res

  defp do_slice(val = _.._, range),
    do: Enum.slice val, range

  defp do_slice(val, range) when is_list(val),
    do: Enum.slice val, range

  defp do_slice(val, range) when is_map(val),
    do: Enum.slice(val, range) |> Enum.into(%{})

  defp do_slice(val, range) when is_tuple(val),
    do: Tuple.to_list(val) |> slice(range)

  defp do_slice(val, range) when is_bitstring(val),
    do: String.slice val, range

  defp do_slice _val, _range do [] end

  def slice(val, at, cnt) when is_number(at) and is_number(cnt) do
    do_slice val, at, cnt
  end

  def slice(_val, _at, _cnt) do :error end
  def slice!(_val, _at, _cnt) do [] end

  defp do_slice(val = _.._, at, cnt),
    do: Enum.slice val, at, cnt

  defp do_slice(val, at, cnt) when is_list(val),
    do: Enum.slice val, at, cnt

  defp do_slice(val, at, cnt) when is_map(val),
    do: Enum.slice(val, at, cnt) |> Enum.into(%{})

  defp do_slice(val, at, cnt) when is_tuple(val),
    do: Tuple.to_list(val) |> do_slice(at, cnt)

  defp do_slice(val, at, cnt) when is_bitstring(val),
    do: String.slice val, at, cnt

  def take(data, cnt) do
    do_take data, cnt
  end

  defp do_take(data, cnt) when cnt > 0 do slice data, 0, cnt end
  defp do_take(data, cnt) when cnt < 0 do slice data, cnt, -(cnt) end
  defp do_take(_, _) do [] end

  def bytes(str), do: byte_size str
  
  def upcase(str) when is_bitstring(str) do
    String.upcase str
  end

  def upcase bad do bad end

  def downcase(str) when is_bitstring(str) do
    String.downcase str
  end

  def downcase bad do bad end

  def reverse val do do_reverse val end

  defp do_reverse(val) when is_map(val) or is_list(val) do
    Enum.reverse val
  end

  defp do_reverse(val) when is_tuple(val) do
    val |> Tuple.to_list |> do_reverse |> List.to_tuple
  end

  defp do_reverse(val) when is_bitstring(val) do String.reverse val end
  defp do_reverse(val) when is_boolean(val) do !(val) end
  defp do_reverse(val) when is_number(val) do -(val) end
  defp do_reverse(val) do val end

end
