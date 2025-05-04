# BamlElixir

Call BAML functions from Elixir.
Uses the BAML Rust NIF to call the BAML library.

What this library does:

- Call functions in BAML files.
- Switch between different LLM clients.
- Get usage data using collectors.

What this library does not do:

- Code generation of Elixir `baml_client` from BAML files.
- Automatically parse BAML results into Elixir structs.

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

Now call the BAML function:

```elixir
BamlElixir.Client.call("ExtractResume", %{resume: "John Doe is the CTO of Acme Inc."}, %{
  path: "priv/baml_src"
})
```

### Stream results

```elixir
BamlElixir.Client.stream!("ExtractResume", %{resume: "John Doe is the CTO of Acme Inc."}, %{
  path: "priv/baml_src"
})
|> Enum.each(&IO.inspect/1)
```

#### Parsing results

If BAML returns a class type, you will get a map with keys as atoms and a special key `__baml_class__` with the BAML class name.

Example:

```elixir
%{
  __baml_class__: "Resume",
  name: "John Doe",
  job_title: "CTO",
  company: %{
    __baml_class__: "Company",
    name: "Acme Inc."
  }
}
```

If BAML returns an enum type, you will get a map two special keys: `__baml_enum__` with the BAML enum name and `value` with the enum value.

Example:

```elixir
%{
  __baml_enum__: "Color",
  value: "Red"
}
```

### Images

Send an image URL:

```elixir
BamlElixir.Client.call("DescribeImage", %{
  myImg: %{
    "url" => "https://upload.wikimedia.org/wikipedia/en/4/4d/Shrek_%28character%29.png"
  }
})
```

Or send base64 encoded image data:

```elixir
BamlElixir.Client.call("DescribeImage", %{
  myImg: %{
    "base64" => "data:image/png;base64,..."
  }
})
```

### Collect usage data

```elixir
collector = BamlElixir.Collector.new("my_collector")

BamlElixir.Client.call("ExtractResume", %{resume: "John Doe is the CTO of Acme Inc."}, %{
  collectors: [collector]
})

BamlElixir.Collector.usage(collector)
```

### Switch LLM clients

From the existing list of LLM clients, you can switch to a different one by calling `Client.use_llm_client/2`.

```elixir
BamlElixir.Client.call("WhichModel", %{}, %{
  llm_client: "GPT4oMini"
})
|> IO.inspect()
# => "gpt-4o-mini"

BamlElixir.Client.call("WhichModel", %{}, %{
  llm_client: "DeepSeekR1"
})
|> IO.inspect()
# => "deepseek-r1"
```

## Installation

Add baml_elixir to your mix.exs:

```elixir
def deps do
  [
    {:baml_elixir, "~> 1.0.0-pre.4"}
  ]
end
```

This also downloads the pre built NIFs for these targets:

- aarch64-apple-darwin (Apple Silicon)
- x86_64-unknown-linux-gnu

If you need to build the NIFs for other targets, you need to clone the repo and build it locally as documented below.

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
- `native/baml_elixir/baml/` - Submodule containing baml which is a dependency of the NIF

### Building

1. Ensure you have Rust installed (https://rustup.rs/). Can use asdf to install it.
2. Build the project:

```bash
mix deps.get
mix compile
```
