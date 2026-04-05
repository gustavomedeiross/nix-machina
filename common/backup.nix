{ pkgs, ... }:

let
  deps = pkgs.lib.makeBinPath [
    pkgs.borgbackup
    pkgs.borgmatic
    pkgs.rclone
    pkgs.coreutils
    pkgs.git
    pkgs.xxHash
    pkgs.msmtp
  ];

  vaultCli = pkgs.runCommand "vault-cli" { } ''
    mkdir -p $out/bin
    cp ${./backup/vault-backup.sh} $out/bin/vault
    chmod +x $out/bin/vault
  '';

  wrappedVaultCli = pkgs.writeShellScriptBin "vault" ''
    export PATH="${deps}:$PATH"
    exec ${vaultCli}/bin/vault "$@"
  '';

  launchdScript = pkgs.runCommand "vault-launchd" { } ''
    mkdir -p $out/bin
    cp ${./backup/vault-launchd.sh} $out/bin/vault-launchd
    chmod +x $out/bin/vault-launchd
  '';

  launchdWrapper = pkgs.writeShellScriptBin "vault-launchd" ''
    export PATH="${deps}:${wrappedVaultCli}/bin:$PATH"
    exec ${launchdScript}/bin/vault-launchd
  '';
in
{
  backupScript = wrappedVaultCli;
  borgmaticConfig = ./backup/borgmatic.yaml;
  inherit launchdWrapper;
}
