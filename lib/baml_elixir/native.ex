defmodule BamlClient.Resume do
  defstruct [:company, :job_title, :name]
end

defmodule BamlElixir.Native do
  use Rustler,
    otp_app: :baml_elixir

  def call(_client, _function_name, _args), do: :erlang.nif_error(:nif_not_loaded)
end
