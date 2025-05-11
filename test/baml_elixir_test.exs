defmodule BamlElixirTest do
  use ExUnit.Case
  use BamlElixir.Client, path: "test/baml_src"
  doctest BamlElixir

  test "parses into a struct" do
    assert {:ok, %BamlElixirTest.Person{name: "John Doe", age: 28}} =
             BamlElixirTest.ExtractPerson.call(%{info: "John Doe, 28, Engineer"})
  end

  test "parsing into a struct with streaming" do
    pid = self()

    BamlElixirTest.ExtractPerson.stream(%{info: "John Doe, 28, Engineer"}, fn result ->
      send(pid, result)
    end)

    messages = wait_for_all_messages()

    # assert more than 1 partial message
    assert Enum.filter(messages, fn {type, _} -> type == :partial end) |> length() > 1

    assert Enum.filter(messages, fn {type, _} -> type == :done end) == [
             {:done, %BamlElixirTest.Person{name: "John Doe", age: 28}}
           ]
  end

  test "change default model" do
    assert BamlElixirTest.WhichModel.call(%{}, %{llm_client: "GPT4"}) == {:ok, :GPT4oMini}
    assert BamlElixirTest.WhichModel.call(%{}, %{llm_client: "DeepSeekR1"}) == {:ok, :DeepSeekR1}
  end

  test "Error when parsing the output of a function" do
    assert {:error, "Failed to coerce value" <> _} = BamlElixirTest.DummyOutputFunction.call(%{})
  end

  test "get usage from collector" do
    collector = BamlElixir.Collector.new("test-collector")

    assert BamlElixirTest.WhichModel.call(%{}, %{llm_client: "GPT4", collectors: [collector]}) ==
             {:ok, :GPT4oMini}

    usage = BamlElixir.Collector.usage(collector)
    assert usage["input_tokens"] == 33
    assert usage["output_tokens"] > 0
  end

  defp wait_for_all_messages(messages \\ []) do
    receive do
      {:partial, _} = message ->
        wait_for_all_messages([message | messages])

      {:done, _} = message ->
        [message | messages] |> Enum.reverse()

      {:error, message} ->
        raise "Error: #{inspect(message)}"
    end
  end
end
