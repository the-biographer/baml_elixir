# BamlElixir

Call BAML functions from Elixir.
Uses the BAML Rust NIF to call the BAML library.

## Installation

Add baml_elixir to your mix.exs:

```elixir
def deps do
  [
    {:baml_elixir, "~> 0.1.0"}
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
