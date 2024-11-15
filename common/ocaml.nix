{ pkgs }:

with pkgs;
with ocamlPackages;
[
  # tools
  dune_3
  findlib
  ocaml
  ocamlformat
  ocaml-lsp
  opam
  odoc
  utop

  # TODO: ideally we would also install the main libraries that I want to have with nix itself
  # lwt
  # ptime
  # uuidm
]
