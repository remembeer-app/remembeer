{ ... }:

{
  dotenv.disableHint = true;

  android = {
    enable = true;
    flutter.enable = true;

    platforms.version = [ "34" "35" "36" ];
    buildTools.version = [ "35.0.0" ];
    ndk.version = [ "28.2.13676358" ];
    abis = [ "x86_64" ];
    systemImageTypes = [ "google_apis_playstore" ];
  };

  scripts.setup.exec = "flutter pub get --enforce-lockfile";

  scripts.create-emulator.exec = ''
    set -euo pipefail

    printf 'no\n' | avdmanager create avd \
      --name remembeer-api-36 \
      --package 'system-images;android-36;google_apis_playstore;x86_64' \
      --device pixel_6_pro
    sed -i 's/^hw.keyboard=no$/hw.keyboard=yes/' \
      "$ANDROID_AVD_HOME/remembeer-api-36.avd/config.ini"
  '';

  scripts.start-emulator.exec = ''
    exec env -u LD_LIBRARY_PATH \
      emulator -avd remembeer-api-36 -gpu host "$@"
  '';
}
