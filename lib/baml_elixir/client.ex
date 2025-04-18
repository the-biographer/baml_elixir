defmodule BamlElixir.Client do
  defstruct [
    :struct_name,
    from: "baml_src",
    stream: true
  ]

  def call(%__MODULE__{} = client, function_name, args) do
    client = %__MODULE__{
      client
      | struct_name: struct_name(client.struct_name)
    }

    if client.stream do
      do_stream(client, function_name, args)
    else
      BamlElixir.Native.call(client, function_name, args)
    end
  end

  defp do_stream(client, function_name, args) do
    pid = self()

    spawn_link(fn ->
      BamlElixir.Native.stream(client, pid, function_name, args)
    end)

    receive do
      x ->
        IO.inspect(x, label: "stream")
    end
  end

  defp struct_name(struct_name) do
    if struct_name do
      struct_name
      |> Module.split()
      |> Enum.join(".")
    else
      ""
    end
  end
end
