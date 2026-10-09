{ pkgs, config, ... }:

{
  dotenv.disableHint = true;

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

  # Use the project's TypeScript 7 LSP so editor types match tsc (including Temporal).
  scripts.typescript-language-server.exec = ''
    exec "${config.devenv.root}/node_modules/.bin/tsc" --lsp "$@"
  '';

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
    # Exclude Android toolchain libraries that provide an incompatible libc++.so,
    # while keeping the host GL/Vulkan drivers available to the emulator.
    # Select NVIDIA for GLX as well as Vulkan on hybrid-GPU systems.
    exec env LD_LIBRARY_PATH="${pkgs.libglvnd}/lib:${pkgs.vulkan-loader}/lib:/run/opengl-driver/lib" \
      __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia \
      emulator -avd remembeer-pixel-9-api-36 -gpu host "$@"
  '';
}
