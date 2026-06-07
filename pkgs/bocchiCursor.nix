{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation {
  name = "bocchiCursor";
  src = ./Bocchi-The-Cursor.tar.gz;  # stays the same since it's in the same pkgs/ folder
  installPhase = ''
    mkdir -p $out/share/icons/Bocchi-The-Cursor
    cp -r ./* $out/share/icons/Bocchi-The-Cursor
  '';
}
