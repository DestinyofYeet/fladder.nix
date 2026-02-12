{
  pkgs,
  buildDartApplication,
  flutter,
  fetchurl,
  stdenv,
  fetchFromGitHub,
  lib,
}:

let
  cleanName = "Fladder";

  version = "0.9.0";

  src = fetchurl {
    url = "https://github.com/DonutWare/Fladder/releases/download/v${version}/Fladder-Linux-${version}.AppImage";
    hash = "sha256-L9dyqEGrMlGW6C7Jj4nhM5X/DlJ3vDNL4pSlsVel8Iw=";
  };

  ghSource = fetchFromGitHub {
    owner = "DonutWare";
    repo = "Fladder";
    tag = "v${version}";
    hash = "sha256-IX3qbIgfi9d8rP24yIGlBzi5l28YQWnvLD+dD+7uIZc=";
  };

  pname = "fladder";

  # unneeded
  pubspecLock = (
    builtins.fromJSON (
      builtins.readFile (
        pkgs.runCommand "pubspec.lock.json" {
          nativeBuildInputs = with pkgs; [
            yq
            busybox
          ];
        } "cat ${ghSource}/pubspec.lock | yq . > $out"
      )
    )
  );

  gitHashes = {
    media_kit = "sha256-oJQ9sRQI4HpAIzoS995yfnzvx5ZzIubVANzbmxTt6LE=";
    media_kit_libs_android_video = "sha256-oJQ9sRQI4HpAIzoS995yfnzvx5ZzIubVANzbmxTt6LE=";
    media_kit_libs_ios_video = "sha256-oJQ9sRQI4HpAIzoS995yfnzvx5ZzIubVANzbmxTt6LE=";
    media_kit_libs_linux = "sha256-oJQ9sRQI4HpAIzoS995yfnzvx5ZzIubVANzbmxTt6LE=";
    media_kit_libs_macos_video = "sha256-oJQ9sRQI4HpAIzoS995yfnzvx5ZzIubVANzbmxTt6LE=";
    media_kit_libs_video = "sha256-oJQ9sRQI4HpAIzoS995yfnzvx5ZzIubVANzbmxTt6LE=";
    media_kit_libs_windows_video = "sha256-oJQ9sRQI4HpAIzoS995yfnzvx5ZzIubVANzbmxTt6LE=";
    media_kit_video = "sha256-oJQ9sRQI4HpAIzoS995yfnzvx5ZzIubVANzbmxTt6LE=";
  };

  build = flutter.buildFlutterApplication {
    inherit
      pname
      version
      src
      gitHashes
      ;

    autoPubspecLock = "${ghSource}/pubspec.lock";

    # nativeBuildInputs = with pkgs; [
    #   pkg-config
    #   ninja
    #   mpv
    # ];
  };

  desktopEntry = pkgs.makeDesktopItem {
    name = pname;
    desktopName = cleanName;
    comment = "A client for Jellyfin";
    exec = "${build}/bin/${pname} %f";
    icon = "${ghSource}/icons/production/fladder_icon_desktop.png";
  };

in
{

  default = stdenv.mkDerivation {
    name = pname;

    src = build;

    installPhase = ''
      mkdir -p $out/bin
      cp bin/${pname} $out/bin/${pname}

      mkdir -p $out/share/applications
      cp ${desktopEntry}/share/applications/${pname}.desktop $out/share/applications/${pname}.desktop
    '';
  };
}
