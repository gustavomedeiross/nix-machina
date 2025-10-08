{ pkgs }:

let
  rust = pkgs.rust-bin.stable.latest.default;
in
with pkgs;
[
  rust
  rust-analyzer
]
