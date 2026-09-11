{ pkgs, ... }:

{
  android = {
    enable = true;
    flutter.enable = true;

    platforms.version = [
      "34" # needed for firestore
      "35" # needed for jni (cached network image)
      "36"
    ];
    buildTools.version = [ "36.0.0" ];
    cmdLineTools.version = "22.0";
    abis = [ "x86_64" ];
  };

  languages.javascript = {
    enable = true;
    package = pkgs.nodejs_24;
    npm.enable = true;
  };

  packages = with pkgs; [
    docker-client
    docker-compose
    openssl
    curl
    jq
  ];

  scripts.createm.exec = ''
    set -euo pipefail

    printf 'no\n' | avdmanager create avd \
      --name remembeer-pixel-9-api-36 \
      --package 'system-images;android-36;google_apis_playstore;x86_64' \
      --device pixel_9
    sed -i 's/^hw.keyboard=no$/hw.keyboard=yes/' \
      "$ANDROID_AVD_HOME/remembeer-pixel-9-api-36.avd/config.ini"
  '';

  scripts.startem.exec = ''
    exec env -u LD_LIBRARY_PATH \
      emulator -avd remembeer-pixel-9-api-36 -gpu host "$@"
  '';
}
