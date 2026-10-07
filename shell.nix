{
  pkgs ? import <nixpkgs> { },
}:

let
  lib = pkgs.lib;
  python = pkgs.python3;

in
pkgs.mkShell {
  packages = with pkgs; [
    nixpkgs-fmt
    python
    python.pkgs.venvShellHook
    ruff
    ty
    uv
  ];

  venvDir = "./.venv";

  UV_PYTHON = "${python}/bin/python";

  UV_PYTHON_DOWNLOADS = "never";
  UV_VENV_CLEAR = "true";

  LD_LIBRARY_PATH = lib.makeLibraryPath [
    pkgs.stdenv.cc.cc
  ];

  shellHook = ''
    uv sync
  '';
}
