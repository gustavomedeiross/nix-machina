{ pkgs }:

# thanks to https://github.com/corps/nix-machines
(pkgs.python3Packages.buildPythonApplication {
  pname = "git-remote-dropbox";
  version = "2.0.4"; # Update this to the latest version

  src = pkgs.fetchFromGitHub {
    owner = "anishathalye";
    repo = "git-remote-dropbox";
    rev = "v2.0.4"; # Update this to match version
    sha256 = "sha256-miA8lYfk77pXn5aWIh17uul1l+7w2VCBDT3+YiVK5OY="; # Add SHA256 after first attempt
  };
  format = "pyproject";

  nativeBuildInputs = with pkgs.python3Packages; [
    hatchling
    hatch-vcs
    poetry-core
    setuptools
  ];

  propagatedBuildInputs = with pkgs.python3Packages; [
    dropbox
    setuptools
    requests
  ];

  doCheck = false; # Skip tests as they might require Dropbox credentials
})
