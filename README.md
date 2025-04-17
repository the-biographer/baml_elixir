# BamlElixir

Call BAML functions from Elixir.
Uses the BAML Rust NIF to call the BAML library.

What this library does:

- Call functions in BAML files.
- Make use of the BAML LLM client to call LLM functions.
- Cast the return values from BAML function calls to the correct structs in Elixir.

What this library does not do:

- Generate `baml_client` Elixir client code from BAML files.

## Usage

First add a BAML file in the `priv` directory.

```baml
client GPT4 {
    provider openai
    options {
        model gpt-4o-mini
        api_key env.OPENAI_API_KEY
    }
}

class Resume {
    name string
    job_title string
    company string
}

function ExtractResume(resume: string) -> Resume {
    client GPT4
    prompt #"
        {{ _.role('system') }}

        Extract the following information from the resume:

        Resume:
        <<<<
        {{ resume }}
        <<<<

        Output JSON schema:
        {{ ctx.output_format }}

        JSON:
    "#
}
```

Now create a module for Resume in your Elixir code:

```elixir
defmodule MyApp.Resume do
  defstruct [:name, :job_title, :company]
end
```

Now call the BAML function:

```elixir
# from: The path to the baml_src directory.
# struct_name: The module name which will be used for the returned struct.
%BamlElixir.Client{from: "priv/baml_src", struct_name: MyApp.Resume}
|> BamlElixir.Client.call("ExtractResume", %{resume: "John Doe is the CTO of Acme Inc."})
```

It's a good idea to create your own client module in your project like this:

```elixir
defmodule MyApp.BamlClient do
  def call(name, args, struct_name \\ nil) do
    client = %BamlElixir.Client{
      from: Application.get_env(:my_app, :baml_src_path),
      struct_name: struct_name
    }

    BamlElixir.call(client, name, args)
  end
end
```

and call it like this:

```elixir
MyApp.BamlClient.call("ExtractResume", %{resume: "John Doe is the CTO of Acme Inc."}, MyApp.Resume)
```

## Installation

Add baml_elixir to your mix.exs:

```elixir
def deps do
  [
    {:baml_elixir, "~> 0.2.0"}
  ]
end
```

### Development

This project includes Git submodules. To clone the repository with all its submodules, use:

```bash
git clone --recurse-submodules <repository-url>
```

If you've already cloned the repository without submodules, initialize them with:

```bash
git submodule init
git submodule update
```

The project includes Rust code in the `native/` directory:

- `native/baml_elixir/` - Main Rust NIF code
- `native/baml/` - Submodule containing baml which is a dependency of the NIF

### Building

1. Ensure you have Rust installed (https://rustup.rs/). Can use asdf to install it.
2. Build the project:

```bash
mix deps.get
mix compile
```

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/baml_elixir>.
