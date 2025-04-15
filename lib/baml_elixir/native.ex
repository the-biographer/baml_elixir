defmodule BamlElixir.Native do
  version = Mix.Project.config()[:version]

  use RustlerPrecompiled,
    otp_app: :baml_elixir,
    base_url: "https://github.com/emilsoman/baml-elixir/releases/download/#{version}/",
    force_build: System.get_env("BAML_ELIXIR_BUILD") in ["1", "true"],
    version: version

  def call(_client, _function_name, _args), do: :erlang.nif_error(:nif_not_loaded)
end
