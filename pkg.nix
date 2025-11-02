{ pkgs, appimageTools, fetchurl }:

let
  version = "0.8.0";
  src = fetchurl {
    url =
      "https://github.com/DonutWare/Fladder/releases/download/v${version}/Fladder-Linux-${version}.AppImage";
    hash = "sha256-uU/QTfAF22d4RPkv7rJrOkn1/LBwMJRv0wLnolxDD/Y=";
  };
  pname = "fladder";

in appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = (_: with pkgs; [ mpv libepoxy ]);
}
