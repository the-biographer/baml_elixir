# How to release

Because we use
[`RustlerPrecompiled`](https://hexdocs.pm/rustler_precompiled/RustlerPrecompiled.html), releasing
is a bit more involved than it would be otherwise.

1. Cut a GitHub release and tag the commit with the version number.
2. This will kick off the "Build precompiled NIFs" GitHub Action. Wait for this to complete. It
   usually takes around 40-60 minutes.
3. While the NIFs are compiling, ensure you have the latest version of `main` and don't have any
   intermediate builds by running `rm -rf native/ex_tokenizers/target`.
4. Once the NIFs are built, use `mix rustler_precompiled.download BamlElixir.Native --all --print` to download generate the checksum file.
5. Run `mix hex.publish`.
6. Bump the version in the `mix.exs` and add the `-dev` flag to it.
