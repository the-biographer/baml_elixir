# How to release

Because we use
[`RustlerPrecompiled`](https://hexdocs.pm/rustler_precompiled/RustlerPrecompiled.html), releasing
is a bit more involved than it would be otherwise.

1. Ensure the version in `mix.exs` is updated.
2. Cut a GitHub release and tag the commit with the version number.
3. This will kick off the "Build precompiled NIFs" GitHub Action. Wait for this to complete. It
   usually takes around 5-10 minutes.
4. While the NIFs are compiling, ensure you have the latest version of `main` and don't have any
   intermediate builds by running `rm -rf native/baml_elixir/target`.
5. Once the NIFs are built, use `mix rustler_precompiled.download BamlElixir.Native --all --print` to download generate the checksum file.
6. Run `mix hex.publish`.
