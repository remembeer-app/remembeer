{ lib, ... }:

{
  dotenv.disableHint = true;

  env.ANDROID_AVD_HOME = lib.mkForce "${builtins.getEnv "HOME"}/.android/avd";

  android = {
    enable = true;
    flutter.enable = true;

    platforms.version = [
      "34"
      "35"
      "36"
    ];
    buildTools.version = [ "36.0.0" ];
    ndk.version = [ "28.2.13676358" ];
    abis = [ "x86_64" ];
    systemImageTypes = [ "google_apis_playstore" ];
  };

  enterShell = ''
    export ANDROID_AVD_HOME="$HOME/.android/avd"
    mkdir -p "$ANDROID_AVD_HOME"
    unset LD_LIBRARY_PATH
  '';

  scripts.setup.exec = "flutter pub get --enforce-lockfile";

  scripts.create-emulator.exec = ''
    set -euo pipefail

    export ANDROID_AVD_HOME="$HOME/.android/avd"
    mkdir -p "$ANDROID_AVD_HOME"

    printf 'no\n' | avdmanager create avd \
      --name pixel-6-pro-api-36 \
      --package 'system-images;android-36;google_apis_playstore;x86_64' \
      --device pixel_6_pro
    sed -i 's/^hw.keyboard=no$/hw.keyboard=yes/' \
      "$ANDROID_AVD_HOME/pixel-6-pro-api-36.avd/config.ini"
  '';

  scripts.start-emulator.exec = ''
    exec env -u LD_LIBRARY_PATH \
      ANDROID_AVD_HOME="$HOME/.android/avd" \
      emulator -avd pixel-6-pro-api-36 -gpu host "$@"
  '';
}
