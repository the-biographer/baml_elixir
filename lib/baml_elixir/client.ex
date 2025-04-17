defmodule BamlElixir.Client do
  defstruct namespace: nil,
            from: "baml_src",
            struct_name: nil

  def call(client, function_name, args) do
    client = %{
      client
      | namespace: client.namespace || "",
        struct_name: struct_name(client.struct_name)
    }

    BamlElixir.Native.call(client, function_name, args)
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
