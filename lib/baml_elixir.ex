defmodule BamlElixir do
  def call(client, function_name, args) do
    BamlElixir.Native.call(client, function_name, args)
  end
end
