{ pkgs }:

with pkgs; with ocamlPackages; [
    ocamlformat
    ocaml
    dune_3
    ocaml-lsp
]
