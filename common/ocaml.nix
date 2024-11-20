{ pkgs }:

with pkgs;
with ocamlPackages;
[
  # tools
  dune_3
  ocamlformat
  ocaml-lsp
  odoc
  # TODO: Fatal error: unknown C primitive `caml_unix_write_bigarray' error on latest install
  utop

  # TODO: ideally we would also install the main libraries that I want to have with nix itself
  # so we don't need to rely on opam
  # ptime
  # uuidm
]
