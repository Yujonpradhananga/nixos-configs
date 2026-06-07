{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation {
  name = "bocchiCursor";
  src = fetchurl {
    url = "https://ocs-dl.fra1.cdn.digitaloceanspaces.com/data/files/1753341936/Bocchi-The-Cursor.tar.gz";
    sha256 = "1lg676hcmh57nqs5nb07bv1lbn601q8dxindq9cdmsqlkxn4h7y0";
  };
  installPhase = ''
    mkdir -p $out/share/icons/Bocchi-The-Cursor
    cp -r ./* $out/share/icons/Bocchi-The-Cursor
  '';
}
