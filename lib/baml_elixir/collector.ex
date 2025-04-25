defmodule BamlElixir.Collector do
  defstruct reference: nil

  def new(name) when is_binary(name) do
    reference = BamlElixir.Native.collector_new(name)
    %__MODULE__{reference: reference}
  end

  def usage(%__MODULE__{reference: reference}) when is_reference(reference) do
    BamlElixir.Native.collector_usage(reference)
  end
end
