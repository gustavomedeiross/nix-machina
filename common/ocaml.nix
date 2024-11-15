{ pkgs }:

with pkgs; with ocamlPackages; [
    dune_3
    ocaml
    ocamlformat
    ocaml-lsp
    utop
]
