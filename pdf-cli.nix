{ stdenv, fetchurl, autoPatchelfHook, lib }:

stdenv.mkDerivation rec {
  pname = "pdf-cli";
  version = "2.0";

  src = fetchurl {
    url = "https://github.com/Yujonpradhananga/pdf-cli/releases/download/v.${version}/pdf-cli";
    sha256 = "sha256-rr8Z8ZUL+R35dJ/tjDM0EPNQbPRLi8Xr6DyUtdEi34M=";
  };

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ autoPatchelfHook ];
  
  # Safety net: allow references just in case, though autoPatchelfHook usually fixes them
  unsafeDiscardReferences = true;

  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/bin
    cp $src $out/bin/pdf-cli
    chmod +x $out/bin/pdf-cli
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "PDF CLI tool";
    platforms = platforms.linux;
  };
}
