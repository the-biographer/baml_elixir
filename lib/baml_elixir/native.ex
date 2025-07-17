defmodule BamlElixir.Native do
  version = Mix.Project.config()[:version]

  use RustlerPrecompiled,
    otp_app: :baml_elixir,
    base_url: "https://github.com/the-biographer/baml_elixir/releases/download/v#{version}/",
    force_build: System.get_env("BAML_ELIXIR_BUILD") in ["1", "true"],
    version: version,
    targets: [
      "aarch64-apple-darwin",
      "x86_64-unknown-linux-gnu"
    ]

  def call(_function_name, _args, _path, _collectors, _client_registry, _tb),
    do: :erlang.nif_error(:nif_not_loaded)

  def stream(_pid, _reference, _function_name, _args, _path, _collectors, _client_registry, _tb),
    do: :erlang.nif_error(:nif_not_loaded)

  def collector_new(_name), do: :erlang.nif_error(:nif_not_loaded)

  def collector_usage(_collector), do: :erlang.nif_error(:nif_not_loaded)

  def collector_last_function_log(_collector), do: :erlang.nif_error(:nif_not_loaded)

  def parse_baml(_path), do: :erlang.nif_error(:nif_not_loaded)
end
